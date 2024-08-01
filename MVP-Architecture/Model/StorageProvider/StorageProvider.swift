//
//  StorageProvider.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import CoreData

enum StoreType {
    case inMemory, persisted
}

class StorageProvider {
    var persistentContainer: NSPersistentContainer
    
    static var managedObjectModel: NSManagedObjectModel = {
       let bundle = Bundle(for: StorageProvider.self)
        guard let url = bundle.url(forResource: "PokemonDataModel", withExtension: "momd") else {
            fatalError("Failed to find PokemonDataModel.momd")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model from: \(url)")
        }
        
        return model
    }()
    
    init(storeType: StoreType = .persisted) {
        persistentContainer = NSPersistentContainer(name: "PokemonDataModel", managedObjectModel: Self.managedObjectModel)
        
        if storeType == .inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreData failed to load with error:\(error)")
            }
        }
    }
}

extension StorageProvider {
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}

extension StorageProvider {
    func getAllData() -> [PokemonDetail] {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}

extension StorageProvider {
    func checkIfFavourite(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let pokeData = try? persistentContainer.viewContext.fetch(fetchRequest)
        guard let pokeData = pokeData, pokeData.count > 0 else { return false }
        return pokeData.first?.name == name
    }
}

extension StorageProvider {
    func delete(name: String) {
        do {
            let fetchRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            
            let pokemonsDetails = try persistentContainer.viewContext.fetch(fetchRequest)
            for pokemon in pokemonsDetails {
                persistentContainer.viewContext.delete(pokemon)
            }
            saveContext()
        } catch {
            debugPrint("CoreData Delete Error:\(error)")
        }
    }
}
