//
//  DetailApiService.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation
import Combine

protocol DetailApiService {
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error>
}

class DefaultDetailApiService: DetailApiService {
    
    let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider = URLSession.shared) {
        self.networkProvider = networkProvider
    }
    
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error> {
        let url = URL(string: url)!
        
        return networkProvider.load(URLRequest(url: url))
            .decode(type: PokemonDetailModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
