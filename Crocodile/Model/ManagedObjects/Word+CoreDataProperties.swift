//
//  Word+CoreDataProperties.swift
//  Crocodile
//
//  Created by Николай Щербаков on 22.06.2023.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var word: String?
    @NSManaged public var category: Category?

}

extension Word : Identifiable {

}
