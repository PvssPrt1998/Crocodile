//
//  GameManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import Foundation

//Главный класс, содержащий все составляющие модели
//Содержит PlayerManager
//Cодержит СategoryManager
//MARK: - GameManager
public class GameManager {
    
    //MARK: - Properties
    //PlayerManager
    private var playerManager: PlayerManager = PlayerManager()
    //CategoryManager
    private var categoryManager: CategoryManager = CategoryManager()
    
    //выбранные слова из категорий
    public var chosenWords: Set<String> = []
    

    
    public func splitSets() {
        for category in categoryManager.categories {
            chosenWords.formUnion(category.wordsSet)
        }
    }
    
    //MARK: - Методы playerManager
    //Добавить игрока
    public func addPlayer(_ playerName: String) {
        playerManager.addPlayer(playerName)
    }
    
    //Удалить игрока
    public func removePlayer(by index: Int) {
        playerManager.removePlayer(by: index)
    }
    
    
    //Вернуть количество игроков
    public func playersCount() -> Int {
        playerManager.playersCount()
    }
    
    //MARK: - Методы
    //загрузить слова
    public func loadWords() {
        categoryManager.loadWords()
    }
    
    //получить категорию по индексу
    private func getCategory(by index: Int) {
        
    }
    
    public func getCategoryTitle(by index: Int) -> String {
        categoryManager.getCategoryTitle(by: index)
    }
    
    
    //сделать категорию выбранной или наоборот
    public func didSelectCategory(by index: Int) {
        categoryManager.didSelectCategory(by: index)
    }
    
    //Есть ли выбранные категории
    public func isAnyCategorySelected() -> Bool {
        categoryManager.isAnyCategorySelected()
    }
    
    //Вернуть количество категорий
    public func categoriesCount() -> Int {
        categoryManager.categoriesCount()
    }
}
