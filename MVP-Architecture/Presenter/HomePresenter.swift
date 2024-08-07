//
//  HomePresenter.swift
//  MVP-Architecture
//
//  Created by russel on 7/8/24.
//
import Foundation
import Combine

class HomePresenter {
    var homeView: HomeView
    var homeApiService: HomeApiService
    var cancellable = Set<AnyCancellable>()
    var hasDataLoaded = false
    
    var pokemonList: [PokemonList] = [PokemonList]()
    var filteredData: [PokemonList] = [PokemonList]()
    
    var isFiltering: Bool {
        filteredData.count > 0
    }
    
    init(homeView: HomeView, homeApiService: HomeApiService = DefaultHomeApiService()) {
        self.homeView = homeView
        self.homeApiService = homeApiService
        
        callApi()
        fetchMoreData()
    }
    
    func callApi() {
        if hasDataLoaded { return }
        homeApiService.fetchPokemonList(offset: pokemonList.count)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] payload in
                guard let self = self else { return }
                pokemonList.append(contentsOf: payload.results)
                homeView.reloadTebleView()
                hasDataLoaded = true
            }
            .store(in: &cancellable)
    }
    
    func fetchMoreData() {
        homeView.fetchMoreData = { [weak self] in
            guard let self = self else { return }
            hasDataLoaded = false
            callApi()
        }
    }
}
