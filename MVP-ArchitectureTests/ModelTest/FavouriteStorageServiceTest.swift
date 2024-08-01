//
//  FavouriteStorageServiceTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import CoreData

@testable import MVP_Architecture

class FavouriteStorageServiceTest: XCTestCase {
    var storageProvider: StorageProvider!
    var sut: FavouriteStorageService!
    
    var firstData: PokemonDetailModel!
    var secondData: PokemonDetailModel!
    var thirdData: PokemonDetailModel!
    
    override func setUpWithError() throws {
        super.setUp()
        storageProvider = StorageProvider(storeType: .inMemory)
        sut = DefaultFavouriteStorageService(storageProvider: storageProvider)
        firstData = PokemonDetailModel(
            height: 6,
            name: "bulbasaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/1/"),
            weight: 8)
        
        secondData = PokemonDetailModel(
            height: 4,
            name: "ivysaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/2/"),
            weight: 5)
        
        thirdData = PokemonDetailModel(
            height: 4,
            name: "venusaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/3/"),
            weight: 5)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        firstData = nil
        secondData = nil
        thirdData = nil
        super.tearDown()
    }
    
    func test_saveTwoData_getTwoBackFromDB() {
        storageProvider.saveData(data:firstData)
        storageProvider.saveData(data:secondData)
        
        let value = sut.getAllFavourites()
        XCTAssertNotEqual(value.count, 1)
        XCTAssertEqual(value.count, 2)
    }
    
    func test_saveThirdDataOnDB_retrieveTheName_itShouldBe_venusaur() {
        storageProvider.saveData(data:thirdData)
        
        let value = sut.getAllFavourites()
        XCTAssertEqual(value.first?.name, "venusaur")
    }
    
    func test_SaveThreeDataOnDB_DeleteOneFromDB_ShouldReturnTwoData() {
        storageProvider.saveData(data:firstData)
        storageProvider.saveData(data:secondData)
        storageProvider.saveData(data:thirdData)
        
        let firstValue = sut.getAllFavourites()
        XCTAssertEqual(firstValue.count, 3)
        
        sut.delete(data: firstData)
        sut.delete(data: secondData)

        let secondValue = sut.getAllFavourites()
        XCTAssertEqual(secondValue.count, 1)
    }
}
