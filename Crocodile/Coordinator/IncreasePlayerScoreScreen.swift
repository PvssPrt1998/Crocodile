//
//  IncreasePlayerScoreScreen.swift
//  Crocodile
//
//  Created by Николай Щербаков on 07.07.2023.
//

import UIKit

//MARK: - IncreasePlayerScoreScreenCoordinator
public class IncreasePlayerScoreScreenCoordinator: Coordinator {

    public var children: [Coordinator] = []
    public var router: Router
    
    // MARK: - Object Lifecycle
    public init(router: Router) {
        self.router = router
    }

    public func present(animated: Bool, onDismissed: (() -> Void)?, data: AnyObject?) {
        //инициализируем наш вью контроллер через сториборд
        //TODO: - скорее всего current height and current width не понадобятся. Проверить это и удалить если надо
        let viewController = IncreasePlayerScoreScreenViewController.instantiate(delegate: self, currentHeight: 300, currentWidth: 300)
        //проверяем прокинули мы данные и являются ли они гейм менеджером. (Надо бы синглтон уже сделать и не напрягаться)
        guard let data = data else { return }
        viewController.setGameManager(data: data)
        //отдаем контроллер роутеру чтобы он как надо презентовал. дисмиссд метод тоже ему отдаем 
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    public func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
}

extension IncreasePlayerScoreScreenCoordinator: IncreasePlayerScoreScreenViewControllerDelegate {
    public func increasePlayerScoreScreenViewControllerDidPressDone() {
        dismiss(animated: true)
    }
}

