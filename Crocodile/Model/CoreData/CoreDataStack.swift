//
//  CoreDataStack.swift
//  Crocodile
//
//  Created by Николай Щербаков on 22.06.2023.
//

import Foundation
import CoreData

//MARK: - CoreDataStack
class CoreDataStack {
    
    //Имя модели
    private let modelName: String
    
    //MARK: - Init
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //managedContext
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    //storeContainer
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                return print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //saveContext
    func saveContext() {
        //Проверяет имеет ли managedContext незакоммиченные изменения
        guard managedContext.hasChanges else { return }
        
        //Коммитим
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
