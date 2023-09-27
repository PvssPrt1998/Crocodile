//
//  DataVersion+CoreDataProperties.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.09.2023.
//
//

import Foundation
import CoreData


extension DataVersion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataVersion> {
        return NSFetchRequest<DataVersion>(entityName: "DataVersion")
    }

    @NSManaged public var version: String?

}

extension DataVersion : Identifiable {

}
