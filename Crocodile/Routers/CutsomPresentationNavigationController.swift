//
//  TransparentNavigationController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 07.07.2023.
//

import UIKit

//MARK: - ScoreNavigationRouter
public class CustomPresentationRouter: NSObject {
    
    
    //MARK: - InstanceProperties
    public unowned let parentViewController: UIViewController
    
    //для каждого viewController
    private var onDismissForViewController: (()->Void)?
    
    //MARK: - Private properties
    //это свойство добавлено чтобы на кастомМодалТранзишинингДелегейт была сильная ссылка
    private var customModalTransitioningDelegate: UIViewControllerTransitioningDelegate?
    
    //MARK: - ObjectLifecycle
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
    }
}

extension CustomPresentationRouter: Router {
    
    //Координатор вызывает этот метод для презентации контроллера
    //Какой конкретный контроллер показать знает только координатор
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        //Назначаем для каждого вьюКонтроллера клоужер который срабатывает при закрытии контроллера
        //чтобы передавать данные предыдущему контроллеру
        onDismissForViewController = onDismissed
        //
        presentCustom(viewController, animated: animated)
    }
    
    //presentCustom method кастомно презентует вьюконтроллер
    private func presentCustom(_ viewController: UIViewController, animated: Bool) {
        //создаем наш кастомный транзишн делегейт и передаем ему ссылку на этот кастом навигейшн
        //вью контроллер содержит слабую ссылку на транзишн делегейт и когда мы инициализируем наш траншишн делегейт в слабой ссылке он не останется в памяти
        //нам надо удерживать наш кастомный делегейт транзишн
        //потому мы сохраняем наш делегейт транзишн в этом классе добавляя свойство
        customModalTransitioningDelegate = CustomModalTransitioningDelegate(presentationControllerFactory: self)
        //обозначаем что модал презентейшн стайл будет кастомным. То есть сами будет описывать как будет показываться
        viewController.modalPresentationStyle = .custom
        //задача транзишн делегейта задача состоит в том, чтобы подать в продажу объекты аниматора, используемые для анимации вьюконтроллера на экран и опционального презентейшенКонтроллера для предоставления любых дополнительных приколов и анимаций.
        //TODO: - возможно потом надо будет дополнить комментарий
        //транзишининг делегейт конкретно мы используем чтобы создать в нем презентейшн контроллер через фабрику
        viewController.transitioningDelegate = customModalTransitioningDelegate
        //Контроллер который вызвал презентацию презентует контроллер который мы хотим отображать
        parentViewController.present(viewController, animated: true)
    }
    
    //Метод который закрывает вью контроллер который отображается. Родительский вьюконтроллер нужен чтобы дисмисснуть отображаемый
    public func dismiss(animated: Bool) {
        performOnDismissed()
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    private func performOnDismissed() {
        //находим метод который должен сработать при закрытии у вьюКонтроллера переданного в параметре
        //Если метода нет, то нет смысла функции выполняться дальше и она завершает работу
        guard let onDismiss = onDismissForViewController else { return }
        //срабатывает метод при закрытии если он есть
        onDismiss()
        //так как вьюКонтроллер закрыт, то делаем нил
        onDismissForViewController = nil
    }
}

//метод фабрики описывается тут
extension CustomPresentationRouter: CustomModalPresentationControllerFactory {
    //этот метод вызывается в транзишининг делегейте для создания кастом презентейшн контроллера
    //то есть транзишнделегейт класс делегирует выполнение этого метода нашему кастомнавигейшн
    //TODO: - вспомнить зачем нужна вообще фабрика
    public func makeCustomModalPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> CustomModalPresentationController {
        //инициализируется и возвращается кастом презентейшн контроллер
        .init(presentedViewController: presentedViewController, presentingViewController: presentingViewController, dismissalHandler: self)
    }
}

//TODO: - скорее всего нам он не понадобится. У нас уже есть дисмиссал хендлер
extension CustomPresentationRouter: CustomModalDismissalHandler {
    public func performDismissal(animated: Bool) {
        dismiss(animated: true)
    }
}
