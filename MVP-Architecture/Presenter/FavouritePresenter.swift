//
//  FavouritePresenter.swift
//  MVP-Architecture
//
//  Created by russel on 7/8/24.
//

import Foundation
import Combine

class FavouritePresenter {
    var favouriteView: FavouriteView!
    var favouriteStorageService: FavouriteStorageService
    
    var detailData = [PokemonDetailModel]()
    
    init(favouriteView: FavouriteView,
         favouriteStorageService: FavouriteStorageService = DefaultFavouriteStorageService()
    ) {
        self.favouriteView = favouriteView
        self.favouriteStorageService = favouriteStorageService
        
        setUp()
    }
    
    func setUp() {
        getAllFavourites()
        deleteFavourite()
    }
    
    func getAllFavourites() {
        let allData = favouriteStorageService.getAllFavourites()
        detailData = allData
        favouriteView.tableView.reloadData()
    }
    
    func deleteFavourite() {
        favouriteView.tapDelete = { [weak self] data in
            guard let self = self else { return }
            favouriteStorageService.delete(data: data)
        }
    }
}
