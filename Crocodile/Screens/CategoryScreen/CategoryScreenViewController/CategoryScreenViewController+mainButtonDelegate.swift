//
//  CategoryScreenViewController+mainButtonAction.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

extension CategoryScreenViewController: MainButtonDelegate {
    func mainButtonTapped(_ button: MainButton) {
        setupSetFromSelectedCategories()
        defer {
            resetAllElementsCollectionView()
        }
        delegate?.mainButtonDidPress(self, onDismissed: onDismissed)
    }
    
    func mainButtonTapping(_ button: MainButton) {
        
    }
}
