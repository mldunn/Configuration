//
//  ConfigurationUITests.swift
//  ConfigurationUITests
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import XCTest

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let chars = stringValue.map { _ in String(Substring(XCUIKeyboardKey.delete.rawValue))
        }
        
        self.typeText(chars.joined(separator: ""))
        self.typeText(text)
    }
}


class ConfigurationUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDiscard() {
        
        let app = XCUIApplication()
        app.buttons["Configuration.Edit"].tap()
        
        
        let textField = getElement(key: "application.emailAddress", fieldType: .textField)
        textField.tap()
        let oldValue = textField.value as! String
        textField.clearAndEnterText(text: "email change")
        app.navigationBars["Settings"].buttons["Done"].tap()
        app.alerts["Alert"].buttons["Discard"].tap()
        
        
        XCUIApplication().buttons["Configuration.Edit"].tap()
        textField.tap()
        XCTAssert(textField.value as! String == oldValue)
    }
    
    
    func testSave() {
        XCUIApplication().buttons["Configuration.Edit"].tap()
        
        let app = XCUIApplication()
        let settingsNavigationBar = app.navigationBars["Settings"]
        let doneButton = settingsNavigationBar.buttons["Done"]
        let saveButton = settingsNavigationBar.buttons["Save"]
        
        let key = "application.emailAddress"
        let replacementText = ("email@test.one","email@test.two")
        _ = replaceText(key: key, newText: replacementText.0)
        
        doneButton.tap()
        
        let alert =  app.alerts["Alert"]
        XCTAssert(alert.buttons["Discard"].exists )
        alert.buttons["Save"].tap()
        doneButton.tap()
        XCUIApplication().buttons["Configuration.Edit"].tap()
        
        
        let textField = getElement(key: key, fieldType: .textField)
        
        XCTAssert(textField.value as! String == replacementText.0)
        
        textField.clearAndEnterText(text: replacementText.1)
        saveButton.tap()
        doneButton.tap()
        XCUIApplication().buttons["Configuration.Edit"].tap()
        
        XCTAssert(textField.value as! String == replacementText.1)
        
    }
    
    func testBoolean() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let settingsNavigationBar = app.navigationBars["Settings"]
        let doneButton = settingsNavigationBar.buttons["Done"]
        let saveButton = settingsNavigationBar.buttons["Save"]
        
        let switchField = getElement(key: "application.enableMultilane", fieldType: .switch)
        
        let oldValue: String = switchField.value as! String
        
        switchField.tap()
        
        saveButton.tap()
        doneButton.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let newValue: String = switchField.value as! String
        
        XCTAssert(oldValue != newValue)
        print(switchField)
        
        switchField.tap()
        
        
        doneButton.tap()
        app.alerts["Alert"].buttons["Discard"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let finalValue: String = switchField.value as! String
        
        XCTAssert(finalValue == newValue)
    }
    
    func testNumber() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let settingsNavigationBar = app.navigationBars["Settings"]
        let doneButton = settingsNavigationBar.buttons["Done"]
        let saveButton = settingsNavigationBar.buttons["Save"]
        let key = "terminalData.transactionCurrencyExponent"
        
        let oldValue: String = replaceText(key: key, newText: "234")
        
        saveButton.tap()
        doneButton.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let numberField = getElement(key: key, fieldType: .textField)
        let newValue: String = numberField.value as! String
        
        XCTAssert(oldValue != newValue)
        
        let lastValue: String = replaceText(key: key, newText: "567")
        
        doneButton.tap()
        app.alerts["Alert"].buttons["Discard"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Configuration.Edit"]/*[[".buttons[\"Edit Settings\"]",".buttons[\"Configuration.Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let finalValue: String = numberField.value as! String
        
        XCTAssert(finalValue == lastValue)
    }
    
    func replaceText(key: String, newText: String) -> String {
        let textField = getElement(key: key, fieldType: .textField)
        let oldValue = textField.value as! String
        textField.clearAndEnterText(text: newText)
        return oldValue
    }
    
    func getElement(key: String,  fieldType: XCUIElement.ElementType) -> XCUIElement {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        let field = tablesQuery.cells.containing(fieldType, identifier: key).children(matching: fieldType).element
        return field
    }
}
