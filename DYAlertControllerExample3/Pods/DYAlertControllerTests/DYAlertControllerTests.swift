//
//  DYAlertControllerTests.swift
//  DYAlertControllerTests
//
//  Created by Dominik Butz on 02/01/2017.
//
//

import XCTest
import DYAlertController

class DYAlertControllerTests: XCTestCase {
    
  
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
   
    
    func testCreateAlert() {
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        
        XCTAssertEqual(controller.style,DYAlertController.Style.alert, "The style was not initialized correctly")
        
        
        XCTAssertEqual(controller.titleText,"Test Title", "no title or title string incorrect")
        
        XCTAssertEqual(controller.messageText,"Test message", "no title or title string incorrect")
        
    }
    

    func testCreateActionSheet() {
        let controller = DYAlertController(style: .actionSheet, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        
        XCTAssertEqual(controller.style,DYAlertController.Style.actionSheet, "The style was not initialized correctly")
        
    }
    
    
    func testTitleAndMessage() {
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        

        XCTAssertEqual(controller.titleText,"Test Title", "no title or title string incorrect")
        
        XCTAssertEqual(controller.messageText,"Test message", "no title or title string incorrect")
    }
    
    
    func testFrameWidth() {
        
        let controller = DYAlertController(style: .actionSheet, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: 300.0, backgroundEffect: .blur)
        
        XCTAssertEqual(controller.contentViewCustomWidth, 300.0, "content view width unexpected")
        
    }
    
    func testAddActions() {
        
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        
        controller.addAction(DYAlertAction(title: "action1", style: .normal, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
            
            print("test1")
        }))
        
        controller.addAction(DYAlertAction(title: "action2", style: .destructive, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
            
            print("test2")
        }))
        
        
        controller.addAction(DYAlertAction(title: "action3", style: .disabled, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
            
            print("test3")
        }))
        
        XCTAssertEqual(controller.alertActions.count, 3, "Incorrect number of actions!")
        
        
        if let action1 = controller.alertActions.first {
            
            XCTAssertEqual(action1.title, "action1", "action title incorrect!")
            XCTAssertEqual(action1.style, ActionStyle.normal, "Action style of 2nd action incorrect")
            
        } else {
            XCTFail("unable to get first action")
        }
        
        
        if let action2 = controller.alertActions[1]  as DYAlertAction? {
            
            XCTAssertEqual(action2.title, "action2", "action title incorrect!")
            XCTAssertEqual(action2.style, ActionStyle.destructive, "Action style of 2nd action incorrect")
            
        }  else {
            XCTFail("unable to get 2nd action")
        }
        
        
        if let action3 = controller.alertActions.last  {
            
            XCTAssertEqual(action3.title, "action3", "action title incorrect!")
            XCTAssertEqual(action3.style, ActionStyle.disabled, "Action style of 3rd action incorrect")
            
        } else {
            XCTFail("unable to get 3rd action")
        }
        
        
    }
    
    func testAddOKButtonTitle() {
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .single, customFrameWidth: nil, backgroundEffect: .blur)
        
        controller.addAction(DYAlertAction(title: "action1", style: .normal, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
            
            print("test1")
        }))
        
        controller.addOKButtonAction("OK", setDisabled: false, setDestructive: false) {
              print("ok button action triggered!")
        }
        


        if let okButtonTitle = controller.okButtonTitle  {
            
            XCTAssertEqual(okButtonTitle, "OK", "ok button title wrong or has no title!")
        } else {
            XCTFail("There is no OK button title")
        }
        
        
    }
    
    
    func testCancelButtonTitle() {
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        
        controller.addAction(DYAlertAction(title: "action1", style: .normal, iconImage: nil, setSelected: false, handler: { (alertAction) -> Void in
            
            print("test1")
        }))
        

        
        if let cancelButtonTitle = controller.cancelButtonTitle  {
            
            XCTAssertEqual(cancelButtonTitle, "Cancel", "cancel button title wrong or has no title!")
        } else {
            XCTFail("There is no cancel button title")
        }
        
        
    }
    
    
    func testAddTextFields() {
        
        
        let controller = DYAlertController(style: .alert, title: "Test Title", titleIconImage: nil, message: "Test message", cancelButtonTitle: "Cancel", checkmarks: .none, customFrameWidth: nil, backgroundEffect: .blur)
        
        controller.addOKButtonAction("OK", setDisabled: false, setDestructive: false) {
               print("ok button action triggered!")
        }
        

        
        let textfield1 = UITextField()
        let textfield2 = UITextField()
        controller.addTextField(textField: textfield1)
        controller.addTextField(textField: textfield2)
        
        XCTAssertEqual(controller.textFields.count, 2, "unexpected number of text fields!")
        
        
        
    }
    
}
