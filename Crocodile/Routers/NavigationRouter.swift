//
//  NavigationRouter.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

//MARK: - NavigationRouter
public class NavigationRouter: NSObject {
    
    //MARK: - InstanceProperties
    //uiwindow передается сюда чтобы назначить для него создаваемый в этом классе navigationController rак rootViewController
    //если не назначить, то для первого контроллера не будет точки входа и будет черный экран
    public let window: UIWindow
    
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (()->Void)] = [:]
    
    //MARK: - ObjectLifecycle
    
    public init(window: UIWindow){
        self.window = window
        self.window.rootViewController = navigationController
        window.makeKeyAndVisible()
        super.init()
        self.navigationController.delegate = self
    }
}

extension NavigationRouter: Router {
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        //Назначаем для каждого вьюКонтроллера клоужер который срабатывает при закрытии контроллера
        //чтобы передавать данные предыдущему контроллеру
        onDismissForViewController[viewController] = onDismissed
        //
        if !navigationController.viewControllers.isEmpty {
            addBackButton(to: viewController)
        }

        navigationController.pushViewController(viewController, animated: animated)
    }
    
    //Метод который срабатывает при закрытии родительского вьюКонтроллера
    //Никогда не вызывается, так как первый контроллер в стеке navigationController является родительским
    public func dismiss(animated: Bool) {
        guard let viewController = navigationController.topViewController else { return }
        performOnDismissed(for: viewController)
        navigationController.popToRootViewController(animated: true)
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
    
    //добавляем стрелку назад
    private func addBackButton(to viewController: UIViewController) {
        let image = UIImage(systemName: "chevron.left")
        guard let image = image else { return }
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButton.tintColor = .black
        viewController.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backButtonPressed() {
        dismiss(animated: true)
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else { return }
        performOnDismissed(for: dismissedViewController)
    }
}
