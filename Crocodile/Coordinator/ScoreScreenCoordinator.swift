//
//  ScoreScreenCoordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 05.07.2023.
//

import UIKit

class ScoreScreenCoordinator: Coordinator {
    
    public var children: [Coordinator] = []
    public var router: Router
    
    //MARK: - Init
    public init(router: Router) {
        self.router = router
    }
    
    //present
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: AnyObject?) {
        //Инициализируем viewController и назначаем делегатом себя чтобы вызывался метод didPressNext конкретно этого класса
        let viewController = ScoreScreenViewController.instantiate()
        //проверяем прокинули мы данные и являются ли они гейм менеджером. (Надо бы синглтон уже сделать и не напрягаться)
        guard let data = data else { return }
        viewController.setGameManager(data: data)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    //dismiss
    public func dismiss(animated: Bool) {
        router.dismiss(animated: true)
    }
}
