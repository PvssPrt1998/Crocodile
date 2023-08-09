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
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: AnyObject?) {
        let viewController = AddPlayersViewController.instantiate(delegate: self)
        guard let data = data else { return }
        viewController.setGameManager(data: data)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    //dismiss
    public func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
}

//MARK: - AddPlayersViewControllerDelegate
extension AddPlayersCoordinator: AddPlayersViewControllerDelegate {
    public func addPlayersViewControllerDidPressNext(_ viewController: AddPlayersViewController, onDismissed: (()->Void)?) {
        let coordinator = GameScreenCoordinator(router: router)
        presentChild(coordinator, animated: true, onDismissed: {
            onDismissed?()
        }, passData: viewController.gameManager)
    }
}

