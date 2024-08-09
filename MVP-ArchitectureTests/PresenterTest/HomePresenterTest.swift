//
//  HomePresenterTest.swift
//  MVP-Architecture
//
//  Created by russel on 8/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class HomePresenterTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    var sut: HomePresenter!
    var homeView: HomeView!
    
    override func setUpWithError() throws {
        homeView = HomeView()
        sut = HomePresenter(homeView: homeView)
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        homeView = nil
        super.tearDown()
    }
    
    func test_whenFetchDataFromHomeApi_and_returnPokemonListModel_successful() throws {
        let json = """
                   { 
                     "count":1302,
                     "next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                     "previous":null,
                     "results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"},{"name":"venusaur","url":"https://pokeapi.co/api/v2/pokemon/3/"},{"name":"charmander","url":"https://pokeapi.co/api/v2/pokemon/4/"},{"name":"charmeleon","url":"https://pokeapi.co/api/v2/pokemon/5/"},{"name":"charizard","url":"https://pokeapi.co/api/v2/pokemon/6/"},{"name":"squirtle","url":"https://pokeapi.co/api/v2/pokemon/7/"},{"name":"wartortle","url":"https://pokeapi.co/api/v2/pokemon/8/"},{"name":"blastoise","url":"https://pokeapi.co/api/v2/pokemon/9/"},{"name":"caterpie","url":"https://pokeapi.co/api/v2/pokemon/10/"}]
                   }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        
        let pokemonDetailModel = try JSONDecoder().decode(PokemonListModel.self, from: data)
        XCTAssertEqual(pokemonDetailModel.results.count, 10)
        
        let homeApiServiceStub = HomeApiServiceStub(returning: .success(pokemonDetailModel))
        sut.homeApiService = homeApiServiceStub
        
        let expectation = XCTestExpectation(description: "Data decoded to PokemonListModel")

        sut.homeApiService
            .fetchPokemonList(offset: 0)
            .sink { _ in}
             receiveValue: { listModel in
                 XCTAssertEqual(homeApiServiceStub.callCount, 1, "total call count")
                 XCTAssertEqual(listModel.results.count, 10)
                 XCTAssertEqual(listModel.results.first?.name, "bulbasaur")
                 XCTAssertEqual(listModel.results.last?.name, "caterpie")

                 expectation.fulfill()
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenHomeApiService_returnsAnError() {
        let expectedError = URLError(.cannotDecodeContentData)
        sut.homeApiService = HomeApiServiceStub(returning: .failure(expectedError))
        
        let expectation = XCTestExpectation(description: "Decoding error")
        
        sut.homeApiService
            .fetchPokemonList(offset: 20)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                XCTAssertEqual(error as? URLError, expectedError)
                expectation.fulfill()
            } receiveValue: { listModel in
                XCTFail("Expected to fail but succeeded with \(listModel)")
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_rowAt_indexPath_return_a_pokemonList() {
        let pokemonList = [
            PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonList(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonList(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            PokemonList(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/5/")
        ]
        sut.pokemonList = pokemonList
        
        let indexPath = IndexPath(row: 2, section: 0)
        let expectedPokemonList = pokemonList[indexPath.row]
        
        let result = sut.rowAt(indexPath: indexPath)
        
        XCTAssertEqual(result, expectedPokemonList)
    }
    
    func test_givenFivePokemonList_returns_fiveRows() {
        let pokemonList = [
            PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonList(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonList(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            PokemonList(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/5/")
        ]
        sut.pokemonList = pokemonList
        
        XCTAssertEqual(sut.numberOfRowsInSection(), 5)
    }
    
    func test_filteredData() {
        let pokemonList = [
            PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonList(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonList(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            PokemonList(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/5/")
        ]
        sut.pokemonList = pokemonList
        
        let _ = sut.filterData(with: "char")
        
        XCTAssertEqual(sut.filteredData.count, 2)
    }
}
