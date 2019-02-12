//
//  ConfigurationService.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation
import CoreData

class ConfigurationService {
    
    private class func createSectionItem(item: XMLItem, context: NSManagedObjectContext) -> SectionItem {
        let sectionItem = SectionItem(context: context)
        sectionItem.id = UUID()
        sectionItem.key = item.tag
        sectionItem.dataType = item.type?.rawValue
        sectionItem.stringvalue = item.textVal
        sectionItem.boolValue = item.boolVal ?? false
        sectionItem.numValue = Int64(item.intVal ?? 0)
        return sectionItem
    }
    
    class func createConfiguration(_ xmlRoot: XMLRoot, managedContext: NSManagedObjectContext) {
    
        // parse the xml data into Section and SectionItem entities
        managedContext.perform {

        
            guard let root = NSEntityDescription.insertNewObject(forEntityName: "Root", into: managedContext) as? Root else {
                LogService.log("createConfiguration -  unable to insert Root entity")
                return
            }
            root.key = xmlRoot.key
            root.version = xmlRoot.version
            root.rootID = UUID()
            
            for data in xmlRoot.sections {
                if let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: managedContext) as? Section {
                    section.name = data.tag
                    section.id = UUID()
                    
                    root.addToSections(section)
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
                LogService.error(error, message: "DataModelService.createConfiguration")
            }
        }
    }
    
    
    
    class func getConfiguration(rootKey: String, rootVersion: String? = nil, managedContext: NSManagedObjectContext) -> Root? {
        
        // perform a basic fetch request for all the Section entities which will include the set of SectionItems for each Section
        
        let request: NSFetchRequest<Root> = Root.fetchRequest(key: rootKey, version: rootVersion)
        
        do {
            return try managedContext.fetch(request).first
        }
        catch let error as NSError {
            LogService.error(error, message: "DataModelService.getConfiguration")
        }
        return nil
    }
}
