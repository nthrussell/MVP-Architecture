//
//  HomeApiServiceTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class HomeApiServiceTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func test_whenLoadDataFromHomeApi_then_decodeToPokemonListModel_successful() throws {
        let json = """
                   { 
                     "count":1302,
                     "next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                     "previous":null,
                     "results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"},{"name":"venusaur","url":"https://pokeapi.co/api/v2/pokemon/3/"},{"name":"charmander","url":"https://pokeapi.co/api/v2/pokemon/4/"},{"name":"charmeleon","url":"https://pokeapi.co/api/v2/pokemon/5/"},{"name":"charizard","url":"https://pokeapi.co/api/v2/pokemon/6/"},{"name":"squirtle","url":"https://pokeapi.co/api/v2/pokemon/7/"},{"name":"wartortle","url":"https://pokeapi.co/api/v2/pokemon/8/"},{"name":"blastoise","url":"https://pokeapi.co/api/v2/pokemon/9/"},{"name":"caterpie","url":"https://pokeapi.co/api/v2/pokemon/10/"},{"name":"metapod","url":"https://pokeapi.co/api/v2/pokemon/11/"},{"name":"butterfree","url":"https://pokeapi.co/api/v2/pokemon/12/"},{"name":"weedle","url":"https://pokeapi.co/api/v2/pokemon/13/"},{"name":"kakuna","url":"https://pokeapi.co/api/v2/pokemon/14/"},{"name":"beedrill","url":"https://pokeapi.co/api/v2/pokemon/15/"},{"name":"pidgey","url":"https://pokeapi.co/api/v2/pokemon/16/"},{"name":"pidgeotto","url":"https://pokeapi.co/api/v2/pokemon/17/"},{"name":"pidgeot","url":"https://pokeapi.co/api/v2/pokemon/18/"},{"name":"rattata","url":"https://pokeapi.co/api/v2/pokemon/19/"},{"name":"raticate","url":"https://pokeapi.co/api/v2/pokemon/20/"}]
                   }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        let apiService = DefaultHomeApiService(networkProvider: NetworkProviderStub(returning: .success(data)))
        
        let expectation = XCTestExpectation(description: "Data decoded to PokemonListModel")

        apiService
            .fetchPokemonList(offset: 0)
            .sink { _ in}
             receiveValue: { listModel in
                 XCTAssertEqual(listModel.results.count, 20)
                 XCTAssertEqual(listModel.results.first?.name, "bulbasaur")
                 XCTAssertEqual(listModel.results.last?.name, "raticate")

                 expectation.fulfill()
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenHomeApiRequest_returnsAnError() {
        let expectedError = URLError(.badServerResponse)
        let apiService = DefaultHomeApiService(networkProvider: NetworkProviderStub(returning: .failure(expectedError)))
        
        let expectation = XCTestExpectation(description: "Received an URLError")
        
        apiService
            .fetchPokemonList(offset: 0)
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
}
