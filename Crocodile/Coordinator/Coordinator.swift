//
//  Coordinator.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import Foundation

//MARK: - Coordinator
public protocol Coordinator: AnyObject {
    //MARK: - Properties
    // в массиве children реализующего протокол класса будут храниться дочерние координаторы. Если их не сохранять в массив они деинициализируются
    var children: [Coordinator] { get set }
    //роутеру скидываем вьюконтроллер и он уже его презентует. Какой контроллер он презентует он не знает. Короче жрет че дают
    var router: Router { get }
    
    //MARK: - Methods
    //метод презент вызывается для презентации вьюконтроллера. В этот вьюконтроллер закидывается дисмисс хэндлер который срабатывает при его закрытии. И прокидывается экземпляр модели
    func present(animated: Bool, onDismissed: (()->Void)?, data: AnyObject?)
    //
    func dismiss(animated: Bool)
    //презент чайлд вызывает метод презент у координатора из чилдрен
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (()->Void)?, passData: AnyObject?)
}

extension Coordinator {
    public func dismiss(animated: Bool) {
        //диссмиссинг делегируется роутеру
        router.dismiss(animated: animated)
    }
    
    public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (()->Void)? = nil, passData: AnyObject?) {
        //добавляем чайлд координатор в массив чилдрен чтобы на него была сильная ссылка и он не деинициилиализировался
        children.append(child)
        //вызываем у координатора чайлд метод презент и прописываем он дисмисс клоужер. хватаем ссылку на координатор вызвавший презент чайлд
        //и ссылку на чайлд. при отработке метода вызвавший координатор удаляет из массива чилдрен чайлд координатора
        child.present(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            //вызывается метод он дисмиссд презент чайлда если он не нил
            onDismissed?()
        }, data: passData)
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child} ) else { return }
        children.remove(at: index)
    }
}
