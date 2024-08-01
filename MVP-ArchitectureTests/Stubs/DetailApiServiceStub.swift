//
//  DetailApiServiceStub.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest
import Combine

@testable import MVP_Architecture

class DetailApiServiceStub: DetailApiService {
    private let result: Result<PokemonDetailModel, Error>
    private(set) var callCount = 0
    private(set) var urls: [String] = []

    init(returning result: Result<PokemonDetailModel, Error>) {
        self.result = result
    }
    
    func fetchDetail(with url:String) -> AnyPublisher<PokemonDetailModel, Error> {
        callCount += 1
        urls.append(url)
        return result.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
