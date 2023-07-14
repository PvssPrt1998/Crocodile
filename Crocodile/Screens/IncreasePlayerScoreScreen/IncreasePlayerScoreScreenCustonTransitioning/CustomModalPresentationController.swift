//
//  CustomModalPresentationController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.07.2023.
//

import UIKit

public final class CustomModalPresentationController: UIPresentationController {
    
    //MARK: - nested type
    //состояния в котором находится вьюКонтроллер
    private enum State {
        case dismissed
        case presenting
        case presented
        case dismissing
    }
    
    //MARK: - Public properties
    //должен ли контроллер показываться на весь экран
    //конкретно этот не должен, делаем false
    public override var shouldPresentInFullscreen: Bool { false }
    
    //определяем тут фрейм контроллера который будет показан. Какую часть экрана будет занимать в конце анимации
    public override var frameOfPresentedViewInContainerView: CGRect {
        targetFrameForPresentedView()
    }
    
    //MARK: - private properties
    //храним текущее состояние вьюконтроллера
    private var state: State = .dismissed
    
    private let dismissalHandler: CustomModalDismissalHandler
    
    //MARK: - Init
    public init(presentedViewController: UIViewController, presentingViewController: UIViewController?, dismissalHandler: CustomModalDismissalHandler) {
        self.dismissalHandler = dismissalHandler
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    //MARK: - UIPresentationController methods
    public override func presentationTransitionWillBegin() {
        state = .presenting
        
        //TODO: - add subviews
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .presented
        } else {
            state = .dismissed
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        state = .dismissing
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .dismissed
        } else {
            state = .presented
        }
    }
    
    
    //MARK: - Private methods
    //определяет фрейм вьюшки нового вьюконтроллера
    private func targetFrameForPresentedView() -> CGRect {
        guard let containerView = containerView else { return .zero }
        
        //берем сейф эреа инсетс у контроллера который инициирует презентацию другого контроллера
        let windowInsets = presentingViewController.view?.window?.safeAreaInsets ?? .zero
        //высота контроллера который будет отображен
        //let preferredHeight = presentedViewController.preferredContentSize.height
        //высота статус бара
        let statusBarHeight = presentingViewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let y = windowInsets.top + statusBarHeight
        let height = presentingViewController.view.bounds.height - (y + windowInsets.bottom)
        let x: CGFloat = 0
        
        let width = containerView.bounds.width - x * 2
        let frame: CGRect = .init(x: x, y: windowInsets.top + statusBarHeight, width: width, height: height)
        
        return frame
    }
}
