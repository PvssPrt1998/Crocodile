//
//  GameManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import Foundation

public protocol GameStateDelegate: AnyObject {
    func prepareGameForInProgressState()
    func prepareGameForWaitingState()
}

//Главный класс, содержащий все составляющие модели
//Содержит PlayerManager
//Cодержит СategoryManager

//MARK: - GameManager
public class GameManager {
    
    //MARK: - Properties
    
    weak var delegate: GameStateDelegate?
    
    var playerManager: PlayerManager = PlayerManager()
    var wordManager: WordManager = WordManager()
    var dataManager: DataManager = DataManager()
    
    var isGameInProgress: Bool = false {
        didSet {
            if isGameInProgress == true {
                wordManager.setCurrentWord()
                delegate?.prepareGameForInProgressState()
            } else {
                playerManager.setCurrentPlayer()
                delegate?.prepareGameForWaitingState()
            }
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
