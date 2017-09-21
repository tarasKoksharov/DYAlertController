//
//  DYAlertControllerTesting.swift
//  DYAlertControllerTesting
//
//  Created by Dominik Butz on 23/11/2016.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import UIKit
import XCTest
import DYAlertController


class DYAlertControllerTesting: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateAlert() {
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)

        XCTAssertEqual(controller.style,DYAlertController.Style.alert, "The style was not initialized correctly")
    }
    

    


    
}
