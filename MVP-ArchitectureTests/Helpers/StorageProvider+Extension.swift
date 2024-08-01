//
//  StorageProvider+Extension.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import Foundation
import CoreData

@testable import MVP_Architecture

extension StorageProvider {
    func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(persistentContainer.viewContext)
        saveContext()
    }
}

extension StorageProvider {
    func deleteData(data: PokemonDetailModel) {
        delete(name: data.name)
    }
}
