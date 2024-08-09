//
//  HomeViewTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
@testable import MVP_Architecture

class HomeViewTest: XCTestCase {
    
    var sut: HomeView!
    var presenter: HomePresenter!
    var mockStorageService: MockDetailStorageService!

    override func setUpWithError() throws {
        let homeApiServiceStub = HomeApiServiceStub(returning: .success(try DecodedPokemonList.SuccessModel()))
        sut = HomeView()
        presenter = HomePresenter(homeView: sut, homeApiService: homeApiServiceStub)
        sut.presenter = presenter
        
        let pokemonList = [
            PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonList(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonList(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            PokemonList(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/5/")
        ]
        
        sut.presenter.pokemonList = pokemonList
    }
    
    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.activityindicatorView)
    }
    
    func test_tableView_whenModelHasFiveList_shouldBeFiveRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 5)
    }
    
    func test_tableView_whenModelHasData_shoulHaveACell() {
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
}
