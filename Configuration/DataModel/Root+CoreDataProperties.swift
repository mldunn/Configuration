//
//  Root+CoreDataProperties.swift
//  Configuration
//
//  Created by michael dunn on 2/11/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension Root {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Root> {
        return NSFetchRequest<Root>(entityName: "Root")
    }

    @NSManaged public var key: String?
    @NSManaged public var rootID: UUID?
    @NSManaged public var version: String?
    @NSManaged public var sections: NSOrderedSet?

}

// MARK: Generated accessors for sections
extension Root {

    @objc(insertObject:inSectionsAtIndex:)
    @NSManaged public func insertIntoSections(_ value: Section, at idx: Int)

    @objc(removeObjectFromSectionsAtIndex:)
    @NSManaged public func removeFromSections(at idx: Int)

    @objc(insertSections:atIndexes:)
    @NSManaged public func insertIntoSections(_ values: [Section], at indexes: NSIndexSet)

    @objc(removeSectionsAtIndexes:)
    @NSManaged public func removeFromSections(at indexes: NSIndexSet)

    @objc(replaceObjectInSectionsAtIndex:withObject:)
    @NSManaged public func replaceSections(at idx: Int, with value: Section)

    @objc(replaceSectionsAtIndexes:withSections:)
    @NSManaged public func replaceSections(at indexes: NSIndexSet, with values: [Section])

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSOrderedSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSOrderedSet)

}
