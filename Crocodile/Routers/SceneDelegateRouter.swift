//
//  SceneDelegateRouter.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

public class SceneDelegateRouter: Router {
    
    public let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    public func dismiss(animated: Bool) {
        //Must be empty
    }
    
    
}
