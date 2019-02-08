//
//  DataModelService.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation
import CoreData

class DataModelService {
    
    
    class func createSectionItem(item: ItemValue, context: NSManagedObjectContext) -> SectionItem {
        let sectionItem = SectionItem(context: context)
        sectionItem.id = UUID()
        sectionItem.key = item.tag
        sectionItem.dataType = item.type?.rawValue
        sectionItem.stringvalue = item.textVal
        sectionItem.boolValue = item.boolVal ?? false
        sectionItem.numValue = Int64(item.intVal ?? 0)
        return sectionItem
    }
    
    class func createConfiguration(_ xmlData: [XMLSection], managedContext: NSManagedObjectContext) {
    
        // parse the xml data into Section and SectionItem entities
        
        for data in xmlData {
            if let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: managedContext) as? Section {
                section.name = data.tag
                section.id = UUID()
                section.position = Int32(data.position)
                for item in data.items {
                    let sectionItem = createSectionItem(item: item, context: managedContext)
                    section.addToItems(sectionItem)
                }
            }
        }
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            LogService.error(error, message: "DataModelService.saveConfiguration")
        }
    }
    
    class func updateConfiguration(_ xmlData: [XMLSection], managedContext: NSManagedObjectContext) {
        
        // parse the xml data into Section and SectionItem entities, checking for updates
        
        let existingSections = getConfiguration(managedContext: managedContext)
        
        for data in xmlData {
            
            if let section = existingSections.first(where: { $0.name == data.tag } ) {
                
                if let items = section.items?.array as? [SectionItem] {
                    let keys: [String] = items.compactMap { $0.key }
                    let existingKeys = Set<String>( keys )
                    let newKeys = Set<String>( data.items.map { $0.tag } )
                    let keysToBeAdded = newKeys.symmetricDifference(existingKeys)
                    if keysToBeAdded.count > 0 {
                        // add section items
                    }
                    let keysToBeRemoved = existingKeys.symmetricDifference(newKeys)
                    if keysToBeRemoved.count > 0 {
                        // remove section items
                    }
                }
            }
            else if let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: managedContext) as? Section {
                section.name = data.tag
                section.id = UUID()
                section.position = Int32(data.position)
                for item in data.items {
                    let sectionItem = createSectionItem(item: item, context: managedContext)
                    section.addToItems(sectionItem)
                }
            }
        }
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            LogService.error(error, message: "DataModelService.saveConfiguration")
        }
    }
    
    class func getConfiguration(managedContext: NSManagedObjectContext) -> [Section] {
        
        // perform a basic fetch request for all the Section entities which will include the set of SectionItems for each Section
        
        let request: NSFetchRequest<Section> = Section.fetchRequest()
        
        // sort by position so we preserve the order of the xml
        
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Section.position), ascending: true)]
        
        do {
            return try managedContext.fetch(request)
        }
        catch let error as NSError {
            LogService.error(error, message: "DataModelService.getConfiguration")
        }
        return []
    }
    
    
}
