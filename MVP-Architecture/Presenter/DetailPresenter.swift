//
//  DetailPresenter.swift
//  MVP-Architecture
//
//  Created by russel on 7/8/24.
//

import Foundation
import Combine

class DetailPresenter {
    var url: String
    var detailView: DetailView!
    var detailApiService: DetailApiService
    var detailStorageService: DetailStorageService
    var data: PokemonDetailModel?
    var cancellable = Set<AnyCancellable>()
        
    init(url: String,
         detailview: DetailView,
         detailApiService: DetailApiService = DefaultDetailApiService(),
         detailStorageService: DetailStorageService = DefaultDetailStorageService()
    ) {
        self.url = url
        self.detailView = detailview
        self.detailApiService = detailApiService
        self.detailStorageService = detailStorageService
        
        callApi()
        observeOnTap()
    }
    
    func observeOnTap() {
        detailView.onTap = { [weak self] data in
            guard let self = self else { return }
            self.detailStorageService.saveOrDelete(with: data)
        }
    }
    
    func checkIfPokemonIsInFavouriteList(data: PokemonDetailModel) {
        let data = detailStorageService.checkIfFavourite(data: data)
        detailView.favouriteButton.isSelected = data ? true : false
    }
    
    func callApi() {
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.data = data
                detailView.updateUI(data: data)
                checkIfPokemonIsInFavouriteList(data: data)
                Loader.hide()
            }
            .store(in: &cancellable)
    }
}
