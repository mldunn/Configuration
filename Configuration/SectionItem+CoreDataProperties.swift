//
//  SectionItem+CoreDataProperties.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension SectionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionItem> {
        return NSFetchRequest<SectionItem>(entityName: "SectionItem")
    }

    @NSManaged public var boolValue: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var key: String?
    @NSManaged public var numValue: Int64
    @NSManaged public var stringvalue: String?
    @NSManaged public var type: Int16
    @NSManaged public var section: Section?

}
