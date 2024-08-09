//
//  DecodedPokemonListModel.swift
//  MVP-Architecture
//
//  Created by russel on 9/8/24.
//

import Foundation
import XCTest
@testable import MVP_Architecture

class DecodedPokemonList {
    static func SuccessModel() throws -> PokemonListModel {
        let json = """
                   { 
                     "count":1302,
                     "next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                     "previous":null,
                     "results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"},{"name":"venusaur","url":"https://pokeapi.co/api/v2/pokemon/3/"},{"name":"charmander","url":"https://pokeapi.co/api/v2/pokemon/4/"},{"name":"charmeleon","url":"https://pokeapi.co/api/v2/pokemon/5/"},{"name":"charizard","url":"https://pokeapi.co/api/v2/pokemon/6/"},{"name":"squirtle","url":"https://pokeapi.co/api/v2/pokemon/7/"},{"name":"wartortle","url":"https://pokeapi.co/api/v2/pokemon/8/"},{"name":"blastoise","url":"https://pokeapi.co/api/v2/pokemon/9/"},{"name":"caterpie","url":"https://pokeapi.co/api/v2/pokemon/10/"}]
                   }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        let pokemonDetailModel = try JSONDecoder().decode(PokemonListModel.self, from: data)
        return pokemonDetailModel
    }
}
