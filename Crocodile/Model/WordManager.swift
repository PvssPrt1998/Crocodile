//
//  WordManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 12.08.2023.
//

import Foundation

//MARK: - WordManager
class WordManager {
    
    //MARK: - Properties
    //текущее слово
    public var currentWord: String?
    
    //выбранные слова из категорий
    public var chosenWords: Set<String> = []
    
    //Берет сеты слов из хранилища кор даты и объединяет их в массив chosen words
    public func addWord(_ word: String) {
        chosenWords.insert(word)
    }
    
    public func setCurrentWord() {
        currentWord = chosenWords.removeFirst()
    }
    
    
}
