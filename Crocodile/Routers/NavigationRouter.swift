//
//  NavigationRouter.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

public class NavigationRouter: NSObject {
    
    //MARK: - InstanceProperties
    public let window: UIWindow
    
    //public unowned let parentViewController: UIViewController
    
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (()->Void)] = [:]
    
    //MARK: - ObjectLifecycle
//    public init(parentViewController: UIViewController) {
//        self.parentViewController = parentViewController
//        super.init()
//        navigationController.delegate = self
//    }
    
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
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        performOnDismissed(for: navigationController.viewControllers.first!)
        //parentViewController?.dismiss(animated: animated, completion: nil)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else { return }
        performOnDismissed(for: dismissedViewController)
    }
}
