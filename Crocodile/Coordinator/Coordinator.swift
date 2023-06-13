//
//  Coordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import Foundation

public protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var router: Router { get }
    
    func present(animated: Bool, onDismissed: (()->Void)?, data: (()->AnyObject?)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (()->Void)?, passData: (()->AnyObject?)?)
}

extension Coordinator {
    public func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
    
    public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (()->Void)? = nil, passData: (()->AnyObject?)?) {
        children.append(child)
//        child.present(animated: animated, onDismissed: { [weak self, weak child] in
//            guard let self = self, let child = child else { return }
//            self.removeChild(child)
//            onDismissed?()
//        }, passData: passData)
        child.present(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        }, data: passData)

        

    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child} ) else { return }
        children.remove(at: index)
    }
}
