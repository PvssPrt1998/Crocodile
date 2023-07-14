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
    
    //текущее слово
    public var currentWord: String?
    
    //выбранные слова из категорий
    public var chosenWords: Set<String> = []
    public var removedWords: Set<String> = []
    
    //Берет сеты слов из хранилища кор даты и объединяет их в массив chosen words
    public func addWordToSet(_ word: String) {
        chosenWords.insert(word)
    }
    
    //Игрок нажал кнопку сдаться
    public func giveUpButtonPressed() {
        playerManager.decrementCurrentPlayerScore()
        playerManager.makeNextPlayerCurrent()
    }
    
    public func setCurrentWord() -> String {
        let word = chosenWords.removeFirst()
        removedWords.insert(word)
        currentWord = word
        return word
    }
    
    public func resetGameManager() {
        chosenWords = []
        removedWords = []
        currentWord = nil
        playerManager = PlayerManager()
    }
}
