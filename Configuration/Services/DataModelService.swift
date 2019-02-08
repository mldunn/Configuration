//
//  DataModelService.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataModelService {
    
    class func saveConfiguration(_ xmlData: [XMLSection], managedContext: NSManagedObjectContext) {
    
        for data in xmlData {
            if let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: managedContext) as? Section {
                section.name = data.tag
                section.id = data.id
                section.position = Int32(data.position)
                for item in data.items {
                    let sectionItem = SectionItem(context: managedContext)
                    sectionItem.id = UUID()
                    sectionItem.key = item.tag
                    sectionItem.dataType = item.type?.rawValue
                    sectionItem.stringvalue = item.val
                    sectionItem.boolValue = item.boolVal ?? false
                    sectionItem.numValue = Int32(item.intVal ?? 0)
                    section.addToItems(sectionItem)
                }
            }
        }
        do {
            try managedContext.save()
        }
        catch  {
            
        }
    }
    
    
    class func getConfiguration(managedContext: NSManagedObjectContext) -> [Section] {
        
        let request: NSFetchRequest<Section> = Section.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Section.position), ascending: true)]
        do {
            return try managedContext.fetch(request)
        }
        catch {
        }
        return []
    }
    
    
}
