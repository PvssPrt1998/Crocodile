//
//  CategoriesOrderedSet+CoreDataProperties.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.10.2023.
//
//

import Foundation
import CoreData


extension CategoriesOrderedSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoriesOrderedSet> {
        return NSFetchRequest<CategoriesOrderedSet>(entityName: "CategoriesOrderedSet")
    }

    @NSManaged public var categories: NSOrderedSet?

}

// MARK: Generated accessors for categories
extension CategoriesOrderedSet {

    @objc(insertObject:inCategoriesAtIndex:)
    @NSManaged public func insertIntoCategories(_ value: Category, at idx: Int)

    @objc(removeObjectFromCategoriesAtIndex:)
    @NSManaged public func removeFromCategories(at idx: Int)

    @objc(insertCategories:atIndexes:)
    @NSManaged public func insertIntoCategories(_ values: [Category], at indexes: NSIndexSet)

    @objc(removeCategoriesAtIndexes:)
    @NSManaged public func removeFromCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoriesAtIndex:withObject:)
    @NSManaged public func replaceCategories(at idx: Int, with value: Category)

    @objc(replaceCategoriesAtIndexes:withCategories:)
    @NSManaged public func replaceCategories(at indexes: NSIndexSet, with values: [Category])

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSOrderedSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSOrderedSet)

}

extension CategoriesOrderedSet : Identifiable {

}
