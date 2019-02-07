//
//  ParserService.swift
//  freedompay
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation


enum ItemType: String, CaseIterable {
    case string
    case bool
    case number
    
    var cellIdentifier: String {
        return rawValue + "Cell"
    }
}

enum SectionTag: String, CaseIterable, CustomStringConvertible {
    case terminalData
    case application
    
    var description: String {
        return rawValue.localized
    }
    
    var tag: String {
        get {
            return rawValue
        }
    }
}

class XMLSection {
    
    var name: String {
        return tag?.description ?? ""
    }
    var key: String {
        return tag?.rawValue ?? ""
    }
    var id: UUID
    var tag: SectionTag?
    var items: [ItemValue] = []
    var itemCount: Int {
        return items.count
    }
    init(tag: String) {
        id = UUID()
        self.tag = SectionTag(rawValue: tag)
    }
}

struct ItemValue {
    var tag: String
    var val: String
    
    var type: ItemType {
        if val.lowercased() == "false" || val.lowercased() == "true" {
            return .bool
        }
        else if let _ = Int(val) {
            return .number
        }
        else {
            return .string
        }
    }
    
    var boolVal: Bool? {
        if type == .bool {
            return val.lowercased() == "true"
        }
        return nil
    }
    
    var intVal: Int? {
        if type == .number {
            return Int(val)
        }
        return nil
    }
}




class ParserService: NSObject {
    var sections: [SectionTag] = []
    var rootName: String
    var fileName: String
   
    var xmlElements: [XMLSection] = []
    var currentXmlSection: XMLSection? = nil
    var currentValue: String = ""
    var currentSection: SectionTag? = nil
    var currentElement: String = ""
    
    var tags: [String] = []

    init(name: String, root: String, tags: [SectionTag]) {
        fileName = name
        rootName = root
        sections = tags
    }
   
    func parse(_ completion: @escaping (Bool, Error?) -> () ) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
            return
        }
        var error: Error?
        error = .none
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            if parser.parse() {
                completion(true, error)
            }
            else {
                completion(false, error)
            }
        }
        else {
            completion(false, error)
        }
    }
}

extension ParserService: XMLParserDelegate {
    
    func parserDidEndDocument(_ parser: XMLParser) {
        LogService.log("parserDidEndDocument")
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        LogService.log("parserDidStartDocument")
        xmlElements = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        LogService.log("didStartElement: \(elementName)")
        
        tags.append(elementName)
       
        // not the root node
        if tags.count > 1 {
        // if elementName != rootName {
            currentElement = elementName
            currentValue = ""
            
           // let section = sections.first (where: { $0.tag == elementName })
            
            if tags.count == 2 {
                
                let xmlSection = XMLSection(tag: elementName)
                
                // elements[section] = []
                // currentSection = section
                currentXmlSection = xmlSection
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        LogService.log("foundIgnorableWhitespace: [\(whitespaceString)]")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        LogService.log("foundCharacters - \(currentElement): \(string)")
        
        currentValue = string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        LogService.log("didEndElement \(elementName)")
        
        if let xmlSection = currentXmlSection {
           
            if tags.count == 2 {// end of section
                xmlElements.append(xmlSection)
                currentXmlSection = nil
            }
        
            else if tags.count > 2 {
                let itemValue = ItemValue(tag: currentElement, val: currentValue)
                xmlSection.items.append(itemValue)
            }
        }
        
      
        print(tags)
        tags.removeLast()
    }
}
