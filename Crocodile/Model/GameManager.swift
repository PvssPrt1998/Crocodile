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
    
    var playerManager: PlayerManager = PlayerManager()
    var wordManager: WordManager = WordManager()
    
    var isGameInProgress: Bool = false {
        didSet {
            if isGameInProgress == true {
                wordManager.setCurrentWord()
            } else {
                playerManager.setCurrentPlayer()
            }
            notifyObservers()
        }
    }
    
    //MARK: - Methods
    //Игрок нажал кнопку сдаться
    func giveUp() {
        playerManager.decrementCurrentPlayerScore()
        isGameInProgress = false
    }
    
     func reset() {
        wordManager = WordManager()
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
