//
//  Category+CoreDataClass.swift
//  Crocodile
//
//  Created by Николай Щербаков on 22.06.2023.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    public var isSelected: Bool = false
}
