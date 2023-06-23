//
//  Category.swift
//  Crocodile
//
//  Created by Николай Щербаков on 03.05.2023.
//

import Foundation

//Содержит имена категорий и может их удалять и добавлять
//Используется чтобы отслеживать какие категории пользователь выбрал
//MARK: - ChosenCategories
public class ChosenCategories {
    
    //выбранные категории
    var categories: Set<String> = []
    
    //Пользователь нажал на категорию. Если категории нет в сете, мы ее добавляем (то есть пользователь ее селектнул)
    //Если категория в сете, мы удаляем это категорию (то есть пользователь ее деселектнул)
    public func didSelectCategory(title: String) {
        if categories.contains(title) {
            //если категория есть в выбранных, мы ее удаляем. Пользователь убрал ее из выбранных
            categories.remove(title)
        } else {
            //если нет, добавляем
            categories.insert(title)
        }
    }
    
    //Выбрана ли хоть одна категория
    public func isAnyCategorySelected() -> Bool {
        !categories.isEmpty
    }
}
