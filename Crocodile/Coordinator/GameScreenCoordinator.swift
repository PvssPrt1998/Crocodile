//
//  GameScreenCoordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 14.06.2023.
//

import UIKit

//MARK: - GameViewControllerCoordinator
public class GameScreenCoordinator: Coordinator {
    
    public var children: [Coordinator] = []
    public var router: Router
    
    //MARK: - Init
    public init(router: Router) {
        self.router = router
    }
    
    //present
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: (()->AnyObject?)?) {
        //Инициализируем viewController и назначаем делегатом себя чтобы вызывался метод didPressNext конкретно этого класса
        let viewController = GameScreenViewController.instantiate(delegate: self)
        //проверяем прокинули мы данные и являются ли они гейм менеджером. (Надо бы синглтон уже сделать и не напрягаться)
        guard let data = data, let data = data() as? GameManager else { return }
        viewController.gameManager = data
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    //dismiss
    public func dismiss(animated: Bool) {
        
    }
}

//MARK: - GameViewControllerDelegate
extension GameScreenCoordinator: GameScreenViewControllerDelegate {
    public func GameViewControllerDidPressNext(_ viewController: GameScreenViewController) {
        
    }
}