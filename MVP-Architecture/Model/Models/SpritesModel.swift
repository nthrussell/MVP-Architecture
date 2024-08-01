//
//  SpritesModel.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import CoreData

struct SpritesModel: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

extension SpritesModel: ModelEntityMapProtocol {
    typealias EntityType = Sprite

    func mapToEntity(_ context: NSManagedObjectContext) -> EntityType {
        let sprite: Sprite = .init(context: context)
        sprite.frontDefault = frontDefault
        return sprite
    }
    
    static func mapFromEntity(_ entity: EntityType) -> Self {
        return .init(frontDefault: entity.frontDefault ?? "")
    }
    
}
