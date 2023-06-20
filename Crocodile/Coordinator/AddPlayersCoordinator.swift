//
//  AddPlayersCoordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//


import UIKit

//MARK: - AddPlayersViewController Coordinator
public class AddPlayersCoordinator: Coordinator {
    
    public var children: [Coordinator] = []
    public var router: Router
    
    //MARK: - Init
    public init(router: Router) {
        self.router = router
    }
    
    //present
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: (()->AnyObject?)?) {
        let viewController = AddPlayersViewController.instantiate(delegate: self)
        guard let data = data, let data = data() as? GameManager else { return }
        viewController.gameManager = data
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    //dismiss
    public func dismiss(animated: Bool) {
        
    }
}

//MARK: - AddPlayersViewControllerDelegate
extension AddPlayersCoordinator: AddPlayersViewControllerDelegate {
    public func addPlayersViewControllerDidPressNext(_ viewController: AddPlayersViewController) {
        let gameManager = viewController.gameManager
        let coordinator = GameScreenCoordinator(router: router)
        presentChild(coordinator, animated: true) {
            return gameManager
        }
    }
}

