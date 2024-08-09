//
//  DetailViewTest.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
@testable import MVP_Architecture

class DetailViewTest: XCTestCase {
    var sut: DetailView!
    var presenter: DetailPresenter!
    var mockStorageService: MockDetailStorageService!
    
    override func setUpWithError() throws {
        sut = DetailView()
        mockStorageService = MockDetailStorageService()
        
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

        let detailApiServiceStub = DetailApiServiceStub(returning: .success(pokemonDetailModel))
        
        presenter = DetailPresenter(url: "", detailview: sut,detailApiService: detailApiServiceStub,  detailStorageService: mockStorageService)
        
        sut.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        mockStorageService = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.containerView)
        XCTAssertNotNil(sut.favouriteButton)
        XCTAssertNotNil(sut.imageView)
        XCTAssertNotNil(sut.nameLabel)
        XCTAssertNotNil(sut.weightlabel)
        XCTAssertNotNil(sut.heightlabel)
    }
    
    func test_updateUI() {
        let detailModelData = PokemonDetailModel(
            height: 10,
            name: "rattata",
            sprites: SpritesModel(frontDefault: "rattata_image"),
            weight: 8)
        
        sut.updateUI(data: detailModelData)
        
        XCTAssertEqual(sut.nameLabel.text, "rattata")
        XCTAssertEqual(sut.heightlabel.text, "height: \(detailModelData.height) cm")
        XCTAssertEqual(sut.weightlabel.text, "weight: \(detailModelData.weight) gm")
        XCTAssertEqual(sut.favouriteButton.isHidden, false)
    }
    
    func test_onTap_succeed_when_touch_up_inside() {
        let tapAddExpectation = expectation(description: "Button tap successful")
        
        let detailModelData = PokemonDetailModel(
            height: 10,
            name: "rattata",
            sprites: SpritesModel(frontDefault: "rattata_image"),
            weight: 8)
        sut.presenter.data = detailModelData
        sut.favouriteButton.isSelected = false
          
        sut.onTap = { _ in
            tapAddExpectation.fulfill()
        }
      
        sut.favouriteButton.sendActions(for: .touchUpInside)
          
        wait(for: [tapAddExpectation], timeout: 0.1)
        XCTAssertEqual(sut.favouriteButton.isSelected, true)
      }
}
