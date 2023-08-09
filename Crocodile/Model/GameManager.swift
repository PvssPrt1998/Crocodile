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
    private var observers: Array<Observer> = []
    
    public var playerManager: PlayerManager = PlayerManager()
    
    var isGameInProgress: Bool {
        didSet {
            if isGameInProgress == true {
                setCurrentWord()
            } else {
                playerManager.setCurrentPlayer()
            }
            notifyObservers()
        }
    }
    
    //текущее слово
    public var currentWord: String?
    
    //выбранные слова из категорий
    public var chosenWords: Set<String> = []
    
    init() {
        isGameInProgress = false
    }
    
    //Берет сеты слов из хранилища кор даты и объединяет их в массив chosen words
    public func addWordToSet(_ word: String) {
        chosenWords.insert(word)
    }
    
    public func prepareForGame() {
        playerManager.setCurrentPlayer()
    }
    
    //Игрок нажал кнопку сдаться
    public func giveUpButtonPressed() {
        playerManager.decrementCurrentPlayerScore()
        isGameInProgress = false
    }
    
    public func setCurrentWord() {
        currentWord = chosenWords.removeFirst()
    }
    
    public func resetGameManager() {
        chosenWords = []
        currentWord = nil
        playerManager = PlayerManager()
    }
}

extension GameManager: Subject {
    func registerObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: Observer) {
        observers.removeAll { $0 === observer }
    }
    
    func notifyObservers() {
        observers.forEach { $0.update(isGameInProgress: isGameInProgress) }
    }
}
