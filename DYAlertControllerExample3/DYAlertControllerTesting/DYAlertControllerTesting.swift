//
//  DYAlertControllerTesting.swift
//  DYAlertControllerTesting
//
//  Created by Dominik Butz on 23/11/2016.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import XCTest

class DYAlertControllerTesting: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        app.buttons["Alert Example 1"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Do stuff 1"].tap()

        
        let actionSheetExample1Button = app.buttons["Action Sheet Example 1"]
        actionSheetExample1Button.tap()
        
        let option2StaticText = tablesQuery.staticTexts["Option 2"]
        option2StaticText.tap()
        tablesQuery.staticTexts["Option 3 - risky"].tap()
        
        let bewareButton = app.buttons["Beware!"]
        bewareButton.tap()
        actionSheetExample1Button.tap()
        
        let option1StaticText = tablesQuery.staticTexts["Option 1"]
        option1StaticText.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
        app.buttons["Action Sheet Example 2"].tap()
        option1StaticText.tap()
        option2StaticText.tap()
        tablesQuery.staticTexts["Risky"].tap()
        bewareButton.tap()
        
    }
    
}
