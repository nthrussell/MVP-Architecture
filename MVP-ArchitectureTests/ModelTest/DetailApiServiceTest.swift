//
//  DetailApiServiceTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class DetailApiServiceTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func test_whenLoadDataFromApi_then_decodeToPokemonDetailModel_successful() throws {
        let json = """
                  {
                     "height":3,
                     "name":"caterpie",
                     "sprites":{
                        "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10.png"
                     },
                     "weight":29
                  }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        let apiService = DefaultDetailApiService(networkProvider: NetworkProviderStub(returning: .success(data)))
        
        let expectation = XCTestExpectation(description: "Data decoded to PokemonDetailModel")
        
        let url = "https://pokeapi.co/api/v2/pokemon/10/"

        apiService
            .fetchDetail(with: url)
            .sink { _ in }
             receiveValue: { detailModel in
                 XCTAssertEqual(detailModel.name, "caterpie")
                 XCTAssertEqual(detailModel.height, 3)
                 XCTAssertEqual(detailModel.weight, 29)
                 XCTAssertNotNil(detailModel.sprites.frontDefault)

                 expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDetailApiRequest_returnsAnError() {
        let expectedError = URLError(.badServerResponse)
        let apiService = DefaultDetailApiService(networkProvider: NetworkProviderStub(returning: .failure(expectedError)))
        
        let expectation = XCTestExpectation(description: "Received an URLError")
        
        let url = "https://pokeapi.co/api/v2/pokemon/10/"
        
        apiService
            .fetchDetail(with: url)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                XCTAssertEqual(error as? URLError, expectedError)
                expectation.fulfill()
            } receiveValue: { detailModel in
                XCTFail("Expected to fail but succeeded with \(detailModel)")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
