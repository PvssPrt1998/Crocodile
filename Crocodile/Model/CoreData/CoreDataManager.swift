//
//  CoreDataManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 22.06.2023.
//

import Foundation
import CoreData

//TODO: - RemoveThisLineLater
import UIKit

class CoreDataManager {
    
    //MARK: - Properties
    enum EntityNames: String {
        case Category
        case Version
    }

    private let modelName: String = "Crocodile"
    
    //CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    var categoriesOrderedSet: CategoriesOrderedSet!
    
    //MARK: - Methods
    //public methods
    
    //метод вытаскивает сет из одной категории и пихает ее в сет другой категории
    //нужно для того чтобы сеты выделенных категорий не сохранять лишний раз в отдельный сет
    //Потом если игра начинается заново мы просто сет со всеми категориями делаем nil
    //И снова делаем феч реквест
    //НИ В КОЕМ СЛУЧАЕ НЕЛЬЗЯ ТУТ В ЭТОМ МЕТОДЕ ПИСАТЬ managedContext.save() или в памяти телефона
    //некоторые категории будут без слов
    func unionSetsOfSelectedCategories() {
        guard let categoriesOrderedSet = categoriesOrderedSet,
              let categories = categoriesOrderedSet.categories
        else { fatalError("Categories doesn't exist") }
        
        for element in categories {
            guard let element = element as? Category else { fatalError("Cannot cast Element of Set to Category Type") }
            if element.isSelected {
                
            }
        }
    }
    
    //get version from device memory and return it
    func getVersion()-> String {
        var version: String = ""
        do {
            //получаем все сущности version которые могут быть. Так как у нас должна быть только одна, то берем первую
            guard let dataVersion = try coreDataStack.managedContext.fetch(DataVersion.fetchRequest()).first,
                  let dataVersion = dataVersion.version
            else { return "" }
            version = dataVersion
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return version
    }
    
    //count of Category entities
    func categoriesCount()-> Int {
        loadSetOfCategoriesIfNeeded()
        guard let categoriesOrderedSet = categoriesOrderedSet,
              let categories = categoriesOrderedSet.categories
        else { return 0 }
        return categories.count
    }
    
    //получаем категорию по индексу
    func getCategory(by index: Int)-> Category? {
        loadSetOfCategoriesIfNeeded()
        guard let categories = categoriesOrderedSet?.categories,
              index >= 0 && index < categories.count,
              let category = categories[index] as? Category
            else { return nil }
        
        return category
    }
    
    //есть ли выбранные категории (is any selected)
    func isAnyCategorySelected()-> Bool {
        guard let categoriesOrderedSet = categoriesOrderedSet,
              let categories = categoriesOrderedSet.categories
        else { fatalError("Categories doesn't exist") }
        
        for element in categories {
            guard let element = element as? Category else { fatalError("Cannot cast Element of Set to Category Type") }
            if element.isSelected {
                return true
            }
        }
        
        return false
    }
    
    //PrivateMethods
    private func loadSetOfCategoriesIfNeeded() {
        if categoriesOrderedSet == nil {
            do {
                let results = try coreDataStack.managedContext.fetch(CategoriesOrderedSet.fetchRequest())
                if results.count > 0 {
                    categoriesOrderedSet = results.first
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
    //TODO: - this method should be moving to DataManager
    //TODO: - This methods should me removed later
    func importDataIfNeeded() {
        let fetchRequest: NSFetchRequest<CategoriesOrderedSet> = CategoriesOrderedSet.fetchRequest()
        let count = try? coreDataStack.managedContext.count(for: fetchRequest)
        
        guard let categoriesCount = count, categoriesCount == 0 else { return }
        importData()
    }

    func importData() {
        let version = DataVersion(context: coreDataStack.managedContext)
        version.version = getDateString()
        
        let categoriesOrderedSet = CategoriesOrderedSet(context: coreDataStack.managedContext)

        let category = Category(context: coreDataStack.managedContext)
        let image = UIImage(named: "Memes")
        category.title = "Memes"
        guard let image = image, let imageData = image.pngData() else { return }
        category.image = imageData
        DELETETHIS.memesWords().forEach { memesWord in
            let word = Word(context: coreDataStack.managedContext)
            word.word = memesWord
            word.category = category
        }
        
        //картинки будут потом через тип дата закидываться, но пока так чтобы затестить работу
        let category1 = Category(context: coreDataStack.managedContext)
        let image1 = UIImage(named: "over18")
        category1.title = "over18"
        guard let image1 = image1, let image1Data = image1.pngData() else { return }
        category1.image = image1Data
        DELETETHIS.over18words().forEach { over18word in
            let word = Word(context: coreDataStack.managedContext)
            word.word = over18word
            word.category = category1
        }
        
        if let categories = categoriesOrderedSet.categories?.mutableCopy() as? NSMutableOrderedSet {
            categories.add(category)
            categories.add(category1)
            categoriesOrderedSet.categories = categories
        }
        
        coreDataStack.saveContext()
        print("dataImported")
    }
    
    
    //MARK: - HelperMethod
    func getDateString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
