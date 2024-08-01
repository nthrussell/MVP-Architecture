//
//  DetailStorageService.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import CoreData

protocol DetailStorageService {
    init(storageProvider: StorageProvider)
    func checkIfFavourite(data: PokemonDetailModel) -> Bool
    func saveOrDelete(with data: PokemonDetailModel)
}

class DefaultDetailStorageService: DetailStorageService {
    
    var storageProvider: StorageProvider
    
    required init(storageProvider: StorageProvider = StorageProvider()) {
        self.storageProvider = storageProvider
    }
    
    func checkIfFavourite(data: PokemonDetailModel) -> Bool {
        storageProvider.checkIfFavourite(name: data.name)
    }
    
    func saveOrDelete(with data: PokemonDetailModel) {
        checkIfFavourite(data: data) ? deleteData(data: data) : saveData(data: data)
    }
    
    private func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(storageProvider.persistentContainer.viewContext)
        storageProvider.saveContext()
    }
    
    private func deleteData(data: PokemonDetailModel) {
        storageProvider.delete(name: data.name)
    }
}
