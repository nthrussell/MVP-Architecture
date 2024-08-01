//
//  MockDetailStorageService.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import XCTest

@testable import MVP_Architecture

class MockDetailStorageService: DetailStorageService {
    
    var storageProvider: StorageProvider
    
    required init(storageProvider: StorageProvider = StorageProvider(storeType: .inMemory)) {
        self.storageProvider = storageProvider
    }
    
    func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(storageProvider.persistentContainer.viewContext)
        storageProvider.saveContext()
    }
    
    func deleteData(data: PokemonDetailModel) {
        storageProvider.delete(name: data.name)
    }
    
    func checkIfFavourite(data: PokemonDetailModel) -> Bool {
        storageProvider.checkIfFavourite(name: data.name)
    }
    
    func saveOrDelete(with data: PokemonDetailModel) {
        checkIfFavourite(data: data) ? storageProvider.delete(name: data.name) : storageProvider.saveData(data: data)
    }
}
