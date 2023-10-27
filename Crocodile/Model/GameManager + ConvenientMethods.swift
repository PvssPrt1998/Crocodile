//
//  GameManager + ConvenientMethods.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.10.2023.
//

import Foundation

//методы классов которые овнит гейм менеджер
//чтобы не писать в контроллере что-то типа gameManager.dataManager.coreDataManager.*MethodName*
//Контроллеру мне кажется не нужно знать что там внутри геймменеджера
extension GameManager {
    //Methods of it's properties for convenience
    func categoriesCount()-> Int {
        dataManager.coreDataManager.categoriesCount()
    }
    
    //Получить категорию по индексу
    func getCategory(by index: Int)-> Category? {
        return dataManager.coreDataManager.getCategory(by: index)
    }
    
    //Есть ли выбранные категории
    func isAnyCategorySelected()-> Bool {
        dataManager.coreDataManager.isAnyCategorySelected()
    }
    
}
