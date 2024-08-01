//
//  HomeApiServiceStub.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class HomeApiServiceStub: HomeApiService {
    private let result: Result<PokemonListModel, Error>
    private(set) var callCount = 0

    init(returning result: Result<PokemonListModel, Error>) {
        self.result = result
    }
    
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        callCount += 1
        return result.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
