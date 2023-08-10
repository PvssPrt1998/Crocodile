//
//  HomeCoordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

public class CategoryCoordinator: Coordinator {

    public var children: [Coordinator] = []
    public var router: Router
    
    // MARK: - Object Lifecycle
    public init(router: Router) {
        self.router = router
    }

    public func present(animated: Bool, onDismissed: (() -> Void)?, data: AnyObject?) {
        let viewController = CategoryScreenViewController.instantiate(delegate: self)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    public func dismiss(animated: Bool) {
        //Do not anything!
    }
}

extension CategoryCoordinator: CategoryScreenViewControllerDelegate {
    public func mainButtonDidPress(_ viewController: CategoryScreenViewController, onDismissed: (()->Void)?) {
        let coordinator = AddPlayersCoordinator(router: router)
        presentChild(coordinator, animated: true, onDismissed: {
            onDismissed?()
        }, passData: viewController.gameManager)
    }
}

