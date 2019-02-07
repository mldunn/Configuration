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
    
    
    class func createConfigurationSection(section: Section, items: [String:String]) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for (name, value) in items.enumerated() {
            let sectionItem = SectionItem(context: managedContext)
//            sectionItem.name = LocalizedString(namee)
//            sectionItem.type = TypeFrom(value)
//            sectionItem.stringvalue = value
//            sectionItem.boolValue = value as? Bool
//            sectionItem.numValue = value as? Int
            
        }
        
        
         //contact.parse(data: json, managedContext: managedContext)
        
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            LogService.error(error, message: "create item")
        }
        
    }
    
    class func createConfiguration(_ data: [String:[String:String]], context: NSManagedObjectContext) {
        
        for key in data.keys {
            if let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: context) as? Section {
                section.name = key
                section.id = UUID()
            }
        }
    }
    
    
    class func getSections() -> [Section] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Section")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context.fetch(request) as? [Section] {
                return result
            }
            
        } catch {
            
            print("Failed")
        }
        return []
    }
    
    
}
