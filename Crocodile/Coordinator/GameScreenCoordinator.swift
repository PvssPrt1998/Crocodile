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
    public func present(animated: Bool, onDismissed: (() -> Void)?, data: AnyObject?) {
        //Инициализируем viewController и назначаем делегатом себя чтобы вызывался метод didPressNext конкретно этого класса
        let viewController = GameScreenViewController.instantiate(delegate: self)
        //проверяем прокинули мы данные и являются ли они гейм менеджером. (Надо бы синглтон уже сделать и не напрягаться)
        guard let data = data else { return }
        viewController.setGameManager(data: data)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

//MARK: - GameViewControllerDelegate
extension GameScreenCoordinator: GameScreenViewControllerDelegate {
    
    public func GameViewControllerDidPressRatingButton(_ viewController: GameScreenViewController) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        let coordinator = ScoreScreenCoordinator(router: router)
        presentChild(coordinator, animated: true, passData: viewController.gameManager)
    }
    
    public func GameViewControllerDidPressGuessed(_ viewController: GameScreenViewController, onDismissed: (()->Void)?) {
        let router = CustomPresentationRouter(parentViewController: viewController)
        let coordinator = IncreasePlayerScoreScreenCoordinator(router: router)
        presentChild(coordinator, animated: true, onDismissed: {
            onDismissed?()
        }, passData: viewController.gameManager)
    }
}
