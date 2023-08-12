//
//  AddPlayerViewController+mainButtonAction.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

extension AddPlayersViewController: MainButtonDelegate {
    func mainButtonTapped(_ button: MainButton) {
        delegate?.addPlayersViewControllerDidPressNext(self, onDismissed: onDismissed)
    }
}
