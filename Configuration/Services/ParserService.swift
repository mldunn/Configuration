//
//  ParserService.swift
//  freedompay
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation


enum Sections: String, CaseIterable {
    case terminalData
    case application
}


class ParserService: NSObject {
    var sections: [String] = []
    var rootName: String
    var fileName: String
    var elements = [String: [String: String]]()
   
    var currentValue: String = ""
    var currentSection: String?
    var currentElement: String = ""
    
    var tags: [String] = []

    init(name: String, root: String, tags: [String]) {
        fileName = name
        rootName = root
        sections = tags
    }
   
    func parse(_ completion: ((Bool, Error) -> ())? ) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
            return
        }
        
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            if parser.parse() {
                print(tags)
                print(self.elements)
            }
        }
    }
}

extension ParserService: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        elements = [:]
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        print("didStartElement \(elementName)")
        
        tags.append(elementName)
        if elementName != rootName {
            currentElement = elementName
            currentValue = ""
            
            
            let section = sections.first (where: { $0 == elementName })
            
            if let section = section {
                currentSection = section
                elements[section] = [:]
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        print("whitespace" )
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        currentValue = string
        print("foundCharacters \(currentElement): \(string)")
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == currentSection {
            // end of section
            currentSection = nil
           
        }
        else if let currentSection = currentSection {
            elements[currentSection]?[currentElement] = currentValue
        }
        
        currentElement = ""
        
        //tags.removeLast()
       
        print("didEndElement \(elementName): \(elementName)")
    }
}
