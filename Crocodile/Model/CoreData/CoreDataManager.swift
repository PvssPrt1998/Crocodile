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

//название наверное лучше сменить
//содержит методы закачки в память устройства
//содержит методы извлечения из памяти устройства
//можно разбить на два класса загрузка в память и выгрузка из памяти
class CoreDataManager {
    
    enum EntityNames: String {
        case Category
        case Version
    }
    
    private let modelName: String = "Crocodile"
    
    //CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    //fetchRequests
    var categoriesFetchRequest: NSFetchRequest<Category>!
    var dataVersionFetchRequest: NSFetchRequest<DataVersion>!
    
    
    //get version from device memory and return it
    func getVersion()-> String {
        var version: String = ""
        do {
            //получаем все сущности version которые могут быть. Так как у нас должна быть только одна, то берем первую
            guard let dataVersion = try coreDataStack.managedContext.fetch(dataVersionFetchRequest).first,
                  let dataVersion = dataVersion.version
            else { return "" }
            version = dataVersion
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return version
    }

    //TODO: - придумать что-нибудь чтобы целый массив не перекидывать, может быть linked list вместо массива. и обработку ошибок запилить чтобы не возвращало
    func getCategoriesArray()-> Array<Category> {
        var categoriesArray: Array<Category> = []
        do { categoriesArray =
            try coreDataStack.managedContext.fetch(categoriesFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return categoriesArray
    }
    
    //TODO: - this method should be moving to DataManager
    func importDataIfNeeded() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let count = try? coreDataStack.managedContext.count(for: fetchRequest)
        
        guard let categoriesCount = count, categoriesCount == 0 else { return }
        importData()
    }

    func importData() {
        let version = DataVersion(context: coreDataStack.managedContext)
        version.version = getDateString()
        coreDataStack.saveContext()
        
        let category = Category(context: coreDataStack.managedContext)
        
        //картинки будут потом через тип дата закидываться, но пока так чтобы затестить работу
        let image = UIImage(named: "Memes")
        let image1 = UIImage(named: "over18")
        
        //добавляем мемы категорию
        category.title = "Memes"
        guard let image = image, let image1 = image1 else { return }
        guard let image = image.pngData(), let image1 = image1.pngData() else { return }
        category.image = image
        coreDataStack.saveContext()
        //добавляем set слов
        DELETETHIS.memesWords().forEach { memesWord in
            let word = Word(context: coreDataStack.managedContext)
            word.category = category
            word.word = memesWord
        }
        //добавляем 18+ категорию
        let category1 = Category(context: coreDataStack.managedContext)
        category1.title = "Over18"
        category1.image = image1
        //добавляем set слов
        DELETETHIS.over18words().forEach { memesWord in
            let word = Word(context: coreDataStack.managedContext)
            word.category = category1
            word.word = memesWord
        }
        
        coreDataStack.saveContext()
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
