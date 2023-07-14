//
//  NavigationSceneDelegateRouter.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

//MARK: - ScoreNavigationRouter
public class ModalNavigationRouter: NSObject {
    
    //MARK: - InstanceProperties
    public unowned let parentViewController: UIViewController
    
    private let navigationController = UINavigationController()
    
    //для каждого viewController
    private var onDismissForViewController: [UIViewController: (()->Void)] = [:]
    
    //MARK: - ObjectLifecycle
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        navigationController.delegate = self
    }
}

extension ModalNavigationRouter: Router {
    
    //Координатор вызывает этот метод для презентации контроллера
    //Какой конкретный контроллер показать знает только координатор
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        //Назначаем для каждого вьюКонтроллера клоужер который срабатывает при закрытии контроллера
        //чтобы передавать данные предыдущему контроллеру
        onDismissForViewController[viewController] = onDismissed
        //Если нет вьюКонтроллеров, то present ViewController Modally (Их нет, но проверку сделаем по приколу)
        //Если каким-то чудом контроллер уже есть, значит где-то ошибка и метод завершает работу
        guard navigationController.viewControllers.count == 0 else { return }
        presentModally(viewController, animated: animated)
    }
    
    //presentModally method
    private func presentModally(_ viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.presentationController?.delegate = self
        parentViewController.present(navigationController, animated: animated, completion: nil)
    }
    
    public func dismiss(animated: Bool) {
        performOnDismissed(for: navigationController.viewControllers.first!)
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        //находим метод который должен сработать при закрытии у вьюКонтроллера переданного в параметре
        //Если метода нет, то нет смысла функции выполняться дальше и она завершает работу
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        //срабатывает метод при закрытии если он есть
        onDismiss()
        //так как вьюКонтроллер закрыт, то делаем нил
        onDismissForViewController[viewController] = nil
    }
}

//MARK: - Extension UINavigationControllerDelegate
extension ModalNavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else { return }
    }
}

//обработка события, когда пользователь закрывает scoreScreenViewController
//реализовано чтобы при свайпе вниз modal presented контроллера деинициализировался класс. иначе он оставался в памяти
extension ModalNavigationRouter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
    }
}
