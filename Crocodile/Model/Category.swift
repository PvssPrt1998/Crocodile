//
//  Category.swift
//  Crocodile
//
//  Created by Николай Щербаков on 03.05.2023.
//

import Foundation

public class Category {
    let title: String
    let wordsSet: Set<String>
    var isSelected: Bool = false
    
    init(title: String, wordsSet: Set<String>) {
        self.title = title
        self.wordsSet = wordsSet
    }
    
    public func toggleSelected() {
        isSelected.toggle()
    }
}
