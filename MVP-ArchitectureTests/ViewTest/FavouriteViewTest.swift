//
//  FavouriteViewTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest

@testable import MVP_Architecture

class FavouriteViewTest: XCTestCase {
    var sut: FavouriteView!
    var presenter: FavouritePresenter!
    var mockStorageService: MockFavouriteStorageService!
    
    override func setUpWithError() throws {
        sut = FavouriteView()
        mockStorageService = MockFavouriteStorageService()
        presenter = FavouritePresenter(favouriteView: sut, favouriteStorageService: mockStorageService)
        sut.presenter = presenter
        
        let detailData = [
            PokemonDetailModel(
                height: 5,
                name: "test1",
                sprites: SpritesModel(frontDefault: "testSprite1"),
                weight: 3),
            PokemonDetailModel(
                height: 4,
                name: "test2",
                sprites: SpritesModel(frontDefault: "testSprite2"),
                weight: 6),
            PokemonDetailModel(
                height: 7,
                name: "test3",
                sprites: SpritesModel(frontDefault: "testSprite7"),
                weight: 3)
        ]
        
        presenter.detailData = detailData
        sut.tableView.reloadData()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        mockStorageService = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_tableView_whenDetailDataHasThreeElement_shouldHaveThreeRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
    }
    
    func test_tableView_whenDetailDataHaveAnElement_shoulHaveACell() {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
}
