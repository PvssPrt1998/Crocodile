//
//  AddPlayerViewController+mainButtonAction.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

extension AddPlayersViewController: MainButtonDelegate {
    func mainButtonTapped(_ button: MainButton) {
        gameManager?.prepareForGame()
        delegate?.addPlayersViewControllerDidPressNext(self, onDismissed: onDismissed)
    }
}
