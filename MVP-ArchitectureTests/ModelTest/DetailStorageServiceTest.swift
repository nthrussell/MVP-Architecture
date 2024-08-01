//
//  DetailStorageServiceTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import CoreData

@testable import MVP_Architecture

class DetailStorageServiceTest: XCTestCase {
    var storageProvider: StorageProvider!
    var sut: DetailStorageService!
    
    var firstData: PokemonDetailModel!
    var secondData: PokemonDetailModel!
    var thirdData: PokemonDetailModel!
    
    override func setUpWithError() throws {
        super.setUp()
        storageProvider = StorageProvider(storeType: .inMemory)
        sut = DefaultDetailStorageService(storageProvider: storageProvider)
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
        super .tearDown()
    }
    
    func test_SaveTwoDataOnDB_ShouldReturnTwoData() {
        storageProvider.saveData(data:firstData)
        storageProvider.saveData(data:secondData)

        let value: [PokemonDetail] = storageProvider.getAllData()
        XCTAssertEqual(value.count, 2)
    }
    
    func test_SaveThreeDataOnDB_DeleteOneFromDB_ShouldReturnTwoData() {
        storageProvider.saveData(data:firstData)
        storageProvider.saveData(data:secondData)
        storageProvider.saveData(data:thirdData)
        
        let firstValue = storageProvider.getAllData()
        XCTAssertEqual(firstValue.count, 3)
        
        storageProvider.deleteData(data: secondData)
        let secondValue = storageProvider.getAllData()
        XCTAssertEqual(secondValue.count, 2)
    }
    
    func test_SaveOneDataOnDB_CheckIfThatNameExists() {
        storageProvider.saveData(data: secondData)
        
        let value = storageProvider.getAllData()
        XCTAssertEqual(value.first?.name, "ivysaur")
        
        XCTAssertFalse(sut.checkIfFavourite(data: firstData))
        XCTAssertTrue(sut.checkIfFavourite(data: secondData))
        XCTAssertFalse(sut.checkIfFavourite(data: thirdData))
    }
    
    func test_SaveOrDelete() {
        storageProvider.saveData(data: firstData)
        storageProvider.saveData(data: secondData)
        
        //Check if data is not there then save
        sut.saveOrDelete(with: thirdData)
        XCTAssertTrue(sut.checkIfFavourite(data: thirdData))
        
        let firstValue = storageProvider.getAllData()
        XCTAssertEqual(firstValue.count, 3)
        
        //Check if data is there then delete
        sut.saveOrDelete(with: firstData)
        XCTAssertFalse(sut.checkIfFavourite(data: firstData))
        
        let secondValue = storageProvider.getAllData()
        XCTAssertEqual(secondValue.count, 2)
    }
}
