//
//  NetworkProviderStub.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation
import Combine

@testable import MVP_Architecture

class NetworkProviderStub: NetworkProvider {
    
    private let result: Result<Data, URLError>

    init(returning result: Result<Data, URLError>) {
        self.result = result
    }
    
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        return result.publisher
            // Use some delay to simulate the real world async behavior
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
