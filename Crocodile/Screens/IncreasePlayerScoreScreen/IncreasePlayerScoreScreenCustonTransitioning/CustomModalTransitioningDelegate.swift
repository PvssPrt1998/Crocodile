//
//  CustomModalTransitioningDelegate.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.07.2023.
//

import UIKit

//фабрика содержит метод который возвращает cutsomModalPresentationController
//CustomModalPresentationController это наш класс который наследуется от UIPresentationController то есть
//Фабрика содержит метод который возвращает кастомный презентейшн контроллер
public protocol CustomModalPresentationControllerFactory {
    func makeCustomModalPresentationController(presentedViewController: UIViewController,
                                               presentingViewController: UIViewController?) -> CustomModalPresentationController
}

public final class CustomModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    //MARK: - Private properties
    //тут хранится ссылка на наш кастом навигейшн контроллер которому делегируется выполнение метода
    //makeCustomModalPresentationController. То есть инициализация презентейшн контроллера
    //детали инициализации описаны в нашем кастом навигейшн контроллере (метод там описан)
    private let presentationControllerFactory: CustomModalPresentationControllerFactory
    
    //MARK: - Init
    //кастом навигейшн контроллер инициализирует кастом транзишининг делегейт и передает ему ссылку на себя (ну ту часть себя которая выполняет
    //метод фабрики)
    init(presentationControllerFactory: CustomModalPresentationControllerFactory) {
        self.presentationControllerFactory = presentationControllerFactory
    }

    //В этом методе инициализируется и возвращается презентейшн контроллер
    //(Из документации) Если вы реализуете этот метод, используйте его для создания и возврата объекта Custom Presentation Controller, который вы хотите использовать для управления процессом презентации.
    //If you don’t implement this method, or if your implementation of this method returns nil, the system uses a default presentation controller object. The default presentation controller doesn’t add any views or content to the view hierarchy.
    //В нашем случае кастомный презентейшн контроллер
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        //вызываем метод кастом навигейшн контроллера (метод фабрики)
        return presentationControllerFactory.makeCustomModalPresentationController(presentedViewController: presented,
                                                                                   presentingViewController: presenting)
    }
    
}
