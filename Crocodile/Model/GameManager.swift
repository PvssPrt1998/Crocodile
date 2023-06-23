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
    public var playerManager: PlayerManager = PlayerManager()
    //CategoryManager
    public var chosenCategories: ChosenCategories = ChosenCategories()
    
    //выбранные слова из категорий
    public var chosenWords: Set<String> = []
    
    //Берет сеты слов из хранилища кор даты и объединяет их в массив chosen words
    public func splitSets() {
        
    }
    
    //MARK: - Методы playerManager
    //Добавить игрока
//    public func addPlayer(_ playerName: String) {
//        playerManager.addPlayer(playerName)
//    }
    
    //Удалить игрока
//    public func removePlayer(by index: Int) {
//        playerManager.removePlayer(by: index)
//    }
    
    
    //Вернуть количество игроков
//    public func playersCount() -> Int {
//        playerManager.playersCount()
//    }
}
