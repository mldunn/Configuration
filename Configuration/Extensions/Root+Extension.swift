//
//  Root+Extension.swift
//  Configuration
//
//  Created by michael dunn on 2/11/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation
import CoreData

extension Root {
    
    class func fetchRequest(key: String, version: String?) -> NSFetchRequest<Root> {
        
        let request: NSFetchRequest<Root> = Root.fetchRequest()
        var predicates: [NSPredicate] = []
        
        predicates.append(NSPredicate(format: "\(#keyPath(Root.key)) == %@", key))
        
        if let version = version {
            predicates.append(NSPredicate(format: "\(#keyPath(Root.version)) == %@", version))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        return request
        
    }
    
    
    var numberOfSections: Int {
        return sections?.count ?? 0
    }
    
    var sectionsArray: [Section]? {
        return sections?.array as? [Section]
    }
    
    func itemCount(index sectionIndex: Int) -> Int {
        guard let sectionsArr = sectionsArray, sectionsArr.count > sectionIndex else {
            return 0
        }
        return sectionsArr[sectionIndex].itemCount
    }
    
    func section(for sectionIndex: Int) -> Section? {
        guard let sectionsArr = sectionsArray, sectionsArr.count > sectionIndex else {
            return nil
        }
        return sectionsArr[sectionIndex]
    }
    
    func sectionItem(for indexPath:  IndexPath) -> SectionItem? {
        guard let sectionsArr = sectionsArray, sectionsArr.count > indexPath.section else {
            return nil
        }
        return sectionsArr[indexPath.section].items?[indexPath.row] as? SectionItem ?? nil
    }
    
}
