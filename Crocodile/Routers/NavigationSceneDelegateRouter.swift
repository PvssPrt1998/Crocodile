//
//  NavigationSceneDelegateRouter.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

public class NavigationSceneDelegateRouter: NSObject {
    
    //MARK: - InstanceProperties
    public let window: UIWindow
    
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (()->Void)] = [:]
    
    //MARK: - ObjectLifecycle
    public init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        super.init()
        navigationController.delegate = self
    }
}

extension NavigationSceneDelegateRouter: Router {
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        
    }
}

extension NavigationSceneDelegateRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else { return }

    }
}

