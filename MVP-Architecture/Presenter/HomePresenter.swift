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
    var hasDataLoaded = false
    
    var pokemonList: [PokemonList] = [PokemonList]()
    var filteredData: [PokemonList] = [PokemonList]()
    
    var isFiltering: Bool {
        filteredData.count > 0
    }
    
    var cancellable = Set<AnyCancellable>()
    
    init(homeView: HomeView, homeApiService: HomeApiService = DefaultHomeApiService()) {
        self.homeView = homeView
        self.homeApiService = homeApiService
        
        callApi()
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
        hasDataLoaded = false
        callApi()
    }
    
    func numberOfRowsInSection() -> Int {
        if isFiltering {
            return filteredData.count
        } else {
            return pokemonList.count
        }
    }
    
    func rowAt(indexPath: IndexPath) -> PokemonList {
        var data: PokemonList
        
        if isFiltering {
            data = filteredData[indexPath.row]
        } else {
            data = pokemonList[indexPath.row]
        }
        
        return data
    }
    
    func pagination(with indexPath: IndexPath) {
        if (indexPath.row == pokemonList.count - 1) && (!isFiltering){
            homeView.tableView.tableFooterView = homeView.activityindicatorView
            homeView.activityindicatorView.startAnimating()
            fetchMoreData()
        }
    }
    
    func filterData(with textSearched: String) {
        filteredData = pokemonList.filter {
            $0.name.lowercased().contains(textSearched.lowercased().trimmingCharacters(in: .whitespaces))
        }
        homeView.reloadTebleView()
    }
}
