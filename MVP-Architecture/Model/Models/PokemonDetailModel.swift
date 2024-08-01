//
//  PokemonDetailModel.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import CoreData

struct PokemonDetailModel: Codable {
    let height: Int
    let name: String
    let sprites: SpritesModel
    let weight: Int
}

extension PokemonDetailModel: ModelEntityMapProtocol {
    typealias EntityType = PokemonDetail

    func mapToEntity(_ context: NSManagedObjectContext) -> EntityType {
        let pokemonDetail: PokemonDetail = .init(context: context)
        pokemonDetail.name = name
        pokemonDetail.height = Int64(height)
        pokemonDetail.weight = Int64(weight)
        
        sprites.mapToEntity(context).pokeDetail = pokemonDetail
        sprites.mapToEntity(context).frontDefault = sprites.frontDefault
        
        return pokemonDetail
    }
    
    static func mapFromEntity(_ entity: EntityType) -> PokemonDetailModel {
        
        guard let sprite = entity.sprites else {
            return .init(
                height: Int(entity.height),
                name: entity.name ?? "",
                sprites: SpritesModel(frontDefault: ""),
                weight: Int(entity.weight))
        }
        
        let spriteModel: SpritesModel = SpritesModel.mapFromEntity(sprite)
                
        return .init(height: Int(entity.height),
                     name: entity.name ?? "",
                     sprites: spriteModel,
                     weight: Int(entity.weight))
    }
}
