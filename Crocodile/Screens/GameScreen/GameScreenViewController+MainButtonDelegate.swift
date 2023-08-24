//
//  GameScreenViewController+MainButtonDelegate.swift
//  Crocodile
//
//  Created by Николай Щербаков on 12.08.2023.
//

import UIKit

extension GameScreenViewController: MainButtonDelegate {
    //Кнопка готовности. При нажатии появляется слово и начинается таймер и кнопка меняется на кнопку "Угадано" и при нажатии появляется окно игроков
    func mainButtonTapped(_ button: MainButton) {
        if gameManager?.isGameInProgress == true {
            presentIncreaseScoreScreenViewController()
        } else {
            
        }
        gameManager?.isGameInProgress.toggle()
    }
    
    func mainButtonTapping(_ button: MainButton) {
        
    }
}
