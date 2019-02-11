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

struct XMLItem {
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
    var items: [XMLItem] = []
    
    var itemCount: Int {
        return items.count
    }
    
    init(tag: String) {
        self.tag = tag
    }
}

struct XMLRoot {
    var key: String
    var version: String?
    var sections: [XMLSection]
    
    init(key: String, version: String? = nil) {
        self.key = key
        self.version = version
        sections = []
    }
    
    var sectionCount: Int {
        return sections.count
    }
}

//
// Parser Service - xml parser
//

class ParserService: NSObject {
    
    private var url: URL?
    private var tagStack: [String] = []
    private let kSectionLevel = 2
    private var rootElement: (String, [String:String])?
    
    var currentSection: XMLSection? = nil
    var currentValue: String = ""
    var currentElement: (String, [String:String])?
    
    var xmlRoot: XMLRoot?
    
    init(bundleIdentifier: String) {
        
        url = Bundle.main.url(forResource: bundleIdentifier, withExtension: "xml")
    }
   
    func parse(_ completion: @escaping (Bool, NSError?) -> () ) {
        
        guard let url = url else {
            LogService.log("ParserService - invalid URL")
            return
        }
        
        var error: NSError?
        error = .none
        
        if let parser = XMLParser(contentsOf: url) {
            
            parser.delegate = self
            
            if parser.parse() {
                LogService.log(xmlRoot.debugDescription)
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

// MARK: XMLParserDelegate

//
// Basic XML parsing service for parsing xml assuming straight structure of <root><section><item>
//
extension ParserService: XMLParserDelegate {
    
    func parserDidEndDocument(_ parser: XMLParser) {
        LogService.log("parserDidEndDocument")
        assert(tagStack.count == 0)
        print(xmlRoot.debugDescription)
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        LogService.log("parserDidStartDocument")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        LogService.log("didStartElement: \(elementName)")
        
        currentElement = (elementName, attributeDict)
        tagStack.append((elementName))
       
        // ignore the root node (tag.count == 1)
        
        if tagStack.count > 1 {
            currentValue = ""
            if tagStack.count == kSectionLevel {
                currentSection = XMLSection(tag: elementName)
            }
        }
        else {
            if let rootElement = currentElement {
                xmlRoot = XMLRoot(key: rootElement.0, version: rootElement.1["version"])
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
        
        if let xmlSection = currentSection {
           
            // see if we are on the section level
            if tagStack.count == kSectionLevel {
                xmlRoot?.sections.append(xmlSection)
                currentSection = nil
            }
            else if tagStack.count > kSectionLevel, let currentElement = currentElement {
                let xmlItem = XMLItem(tag: currentElement.0, attribs: currentElement.1, textVal: currentValue)
                xmlSection.items.append(xmlItem)
            }
        }
        
        // pop the tag, since we are done processing the element
        tagStack.removeLast()
    }
}
