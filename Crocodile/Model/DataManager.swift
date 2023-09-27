//
//  DataManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.09.2023.
//

import Foundation

//этот класс проверяет одинаковы ли версии в файрбейзе и в памяти устройства. Если версия новая, скачивает с файрбейза и закидывает в память телефона
//Если старая, подгрузки данных не будет
//имеет методы предоставления данных контроллеру по запросу
class DataManager {
    
    var categoriesArray: Array<Category> = []
    
    let coreDataManager = CoreDataManager()
    
    func fillCategoriesArrayFromDeviceMemory() {
        categoriesArray = coreDataManager.getCategoriesArray()
    }
    
    //проверяет отличается ли версия в облаке от версии в памяти телефона
    func checkUpdates() {
        
    }
    
    
}
