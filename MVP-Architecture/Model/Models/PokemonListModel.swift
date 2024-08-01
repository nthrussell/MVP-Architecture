//
//  PokemonListModel.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation

struct PokemonListModel: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PokemonList]
}

struct PokemonList: Codable {
    let name: String
    let url: String
}
