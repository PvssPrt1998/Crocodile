//
//  AddPlayersCoordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//


import UIKit

public class AddPlayersCoordinator: Coordinator {
    
    public var children: [Coordinator] = []
    public var router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    deinit{
        print("addplayersCoordinatorDeinit")
    }
    
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: (()->AnyObject?)?) {
        let viewController = AddPlayersViewController.instantiate(delegate: self)
//        if data != nil{
//            if let data = data!() as? GameManager {
//                viewController.gameManager = data
//            }
//        }
        guard let data = data, let data = data() as? GameManager else { return }
        viewController.gameManager = data
        
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension AddPlayersCoordinator: AddPlayersViewControllerDelegate {
    public func addPlayersViewControllerDidPressNext(_ viewController: CategoryViewController) {
        
    }
}

