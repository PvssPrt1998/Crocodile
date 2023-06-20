//
//  WordsManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 19.06.2023.
//

import Foundation

//Содержит категории и может их удалять и добавлять
//MARK: - CategoryManager
public class CategoryManager {
    
    
    
    //MARK: - Properties
    //Массив категорий
    var categories: [Category] = []

    //Костыль сделанные до реализации кор дата и файрбейз
    var memesWords: Set = ["MemeWord1", "MemeWord2", "MemeWord3", "MemeWord4", "MemeWord5", "MemeWord6", "MemeWord7", "MemeWord8", "MemeWord9", "MemeWord10", "MemeWord11", "MemeWord12", "MemeWord13", "MemeWord14", "MemeWord15"]
    var over18words: Set = ["over18words1", "over18words2", "over18words3", "over18words4", "over18words5", "over18words", "over18words7", "over18words8", "over18words9", "over18words10", "over18words11", "over18words12", "over18words13", "over18words14", "over18words15"]
    //
    
    
    //MARK: - Methods
    //загрузить слова
    public func loadWords() {
        categories.append(Category(title: "Memes", wordsSet: memesWords))
        categories.append(Category(title: "Over18", wordsSet: over18words))
    }
    
    //Получить категорию по индексу
    public func getCategoryTitle(by index: Int) -> String {
        //TODO: - сделать проверку на выход за границы массива и проверить необходимо ли это
        categories[index].title
    }
    
    //Пользователь нажал на категорию. Мы перещелкиваем ее на выбранную или невыбранную
    public func didSelectCategory(by index: Int) {
        //TODO: - сделать проверку на выход за границы массива и проверить необходимо ли это
        categories[index].toggleSelected()
    }
    
    //Выбрана ли хоть одна категория
    public func isAnyCategorySelected() -> Bool {
        categories.contains { $0.isSelected == true }
    }
    
    //Вернуть количество категорий
    public func categoriesCount() -> Int {
        categories.count
    }
    
    
    
    
    
    
}
