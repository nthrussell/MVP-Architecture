//
//  ModelEntityMapProtocol.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation
import CoreData

protocol ModelEntityMapProtocol {
    associatedtype EntityType: NSManagedObject

    func mapToEntity(_ context: NSManagedObjectContext) -> EntityType
    static func mapFromEntity(_ entity: EntityType) -> Self
}
