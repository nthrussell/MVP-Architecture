//
//  DetailViewControllerTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class DetailViewControllerTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    var sut: DetailViewController!
    var mockStorageService: MockDetailStorageService!
    var detailView: DetailView!
    
    override func setUpWithError() throws {
        mockStorageService = MockDetailStorageService()
        sut = DetailViewController(url: "", detailStorageService: mockStorageService)
        detailView = DetailView()
        
        sut.detailView = detailView
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockStorageService = nil
        detailView = nil
        super.tearDown()
    }
    
    func test_ifObserveOnTap_gets_a_pokemonDetailModel_and_saveItToFavourite() {
        let data = PokemonDetailModel(
            height: 5,
            name: "test",
            sprites: SpritesModel(frontDefault: "image url"),
            weight: 9
        )
        
        sut.observeOnTap()
        
        detailView.updateUI(data: data)
        detailView.onTap?(data)
        
        XCTAssertTrue(mockStorageService.checkIfFavourite(data: data))
    }
    
    func test_whenFetchSuccessful_And_SaveAsFavourite_Successful() throws {
        let json = """
                   { 
                     "height": 6,
                     "name":"bulbasur",
                     "weight": 7,
                     "sprites" : {
                                   "front_default": "some image url"
                                 }
                   }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        
        let pokemonDetailModel = try JSONDecoder().decode(PokemonDetailModel.self, from: data)
        XCTAssertEqual(pokemonDetailModel.sprites.frontDefault, "some image url")
        
        let detailApiServiceStub = DetailApiServiceStub(returning: .success(pokemonDetailModel))
        sut.detailApiService = detailApiServiceStub
        
        let expectation = XCTestExpectation(description: "Data decoded to PokemonListModel")

        sut.detailApiService
            .fetchDetail(with: "some url")
            .sink { _ in}
             receiveValue: { detailModel in
                 XCTAssertEqual(detailApiServiceStub.callCount, 1, "total call count")
                 XCTAssertEqual(detailApiServiceStub.urls.first, "some url", "first url")

                 self.mockStorageService.saveData(data: detailModel)
                 
                 XCTAssertEqual(detailModel.name, "bulbasur")
                 XCTAssertEqual(detailModel.height, 6)
                 XCTAssertEqual(detailModel.weight, 7)
                 XCTAssertEqual(detailModel.sprites.frontDefault, "some image url")
                 XCTAssertTrue(self.mockStorageService.checkIfFavourite(data: detailModel))

                 expectation.fulfill()
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDetailApiService_returnsAnError() {
        let expectedError = URLError(.cannotDecodeContentData)
        sut.detailApiService = DetailApiServiceStub(returning: .failure(expectedError))
        
        let expectation = XCTestExpectation(description: "Decoding error")
        
        sut.detailApiService
            .fetchDetail(with: "some url")
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
