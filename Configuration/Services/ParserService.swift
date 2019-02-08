//
//  ParserService.swift
//  freedompay
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation

// MARK: XML Helper enum, struct and class to represent parsed xml

enum ItemType: String, CaseIterable {
    case text
    case bool
    case int
    
    var cellIdentifier: String {
        return rawValue + "Cell"
    }
}

struct ItemValue {
    var tag: String
    var attribs: [String: String] = [:]
    
    var type: ItemType? {
        if let dataType = attribs["type"] {
            return ItemType(rawValue: dataType)
        }
        return ItemType(rawValue: "text")
    }
    
    var textVal: String
    
    var boolVal: Bool? {
        if type == .bool {
            return textVal.lowercased() == "true"
        }
        return nil
    }
    
    var intVal: Int? {
        if type == .int {
            return Int(textVal)
        }
        return nil
    }
}


class XMLSection {
    
    var tag: String
    var position: Int
    var items: [ItemValue] = []
    
    var itemCount: Int {
        return items.count
    }
    
    init(tag: String, position: Int) {
        self.tag = tag
        self.position = position
    }
}

//
// Parser Service - xml parser
//

class ParserService: NSObject {
    
    var fileName: String
   
    var xmlElements: [XMLSection] = []
    var currentXmlSection: XMLSection? = nil
    var currentValue: String = ""
    var currentElement: (String, [String:String])?
    
    private var tags: [String] = []
    private let kSectionLevel = 2
    
    init(name: String) {
        fileName = name
    }
   
    func parse(_ completion: @escaping (Bool, NSError?) -> () ) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
            return
        }
        
        var error: NSError?
        error = .none
        
        if let parser = XMLParser(contentsOf: url) {
            
            parser.delegate = self
            
            if parser.parse() {
                LogService.log(xmlElements.debugDescription)
                completion(true, error)
            }
            else {
                error = NSError(domain: "ParserService",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "XMLParser failed"])
                completion(false, error)
            }
        }
        else {
            error = NSError(domain: "ParserService",
                            code: 101,
                            userInfo: [NSLocalizedDescriptionKey: "unable to create XMLParser"])
            completion(false, error)
        }
    }
}

extension ParserService: XMLParserDelegate {
    
    func parserDidEndDocument(_ parser: XMLParser) {
        LogService.log("parserDidEndDocument")
        assert(tags.count == 0)
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        LogService.log("parserDidStartDocument")
        xmlElements = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        LogService.log("didStartElement: \(elementName)")
        
        currentElement = (elementName, attributeDict)
        tags.append((elementName))
       
        // ignore the root node (tag.count == 1)
        
        if tags.count > 1 {
            currentValue = ""
            if tags.count == kSectionLevel {
                currentXmlSection = XMLSection(tag: elementName, position: xmlElements.count)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        LogService.log("foundIgnorableWhitespace: [\(whitespaceString)]")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        LogService.log("foundCharacters - \(String(describing: currentElement?.0)): \(string)")
        currentValue = string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        LogService.log("didEndElement \(elementName)")
        
        if let xmlSection = currentXmlSection {
           
            // see if we are on the section level
            if tags.count == kSectionLevel {
                xmlElements.append(xmlSection)
                currentXmlSection = nil
            }
            else if tags.count > kSectionLevel, let currentElement = currentElement {
                let itemValue = ItemValue(tag: currentElement.0, attribs: currentElement.1, textVal: currentValue)
                xmlSection.items.append(itemValue)
            }
        }
        
        // pop the tag, since we are done processing
        tags.removeLast()
    }
}
