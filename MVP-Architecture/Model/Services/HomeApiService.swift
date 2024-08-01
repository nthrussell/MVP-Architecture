//
//  HomeApiService.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation
import Combine

protocol HomeApiService {
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error>
}

class DefaultHomeApiService: HomeApiService {
    let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider = URLSession.shared) {
        self.networkProvider = networkProvider
    }
    
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        var url = URL(string: Constant.URL.baseURL + "/pokemon")!
        url.append(queryItems: [URLQueryItem(name: "limit", value: "\(20)"),
                               URLQueryItem(name: "offset", value: "\(offset)")])
        
        return networkProvider.load(URLRequest(url: url))
            .decode(type: PokemonListModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
