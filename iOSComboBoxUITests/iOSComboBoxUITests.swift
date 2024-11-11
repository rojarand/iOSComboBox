//
//  iOSComboBoxUITests.swift
//  iOSComboBoxUITests
//
//  Created by Robert Andrzejczyk on 15/03/2024.
//

import XCTest

@testable import iOSComboBox


extension XCUIElement {
    func waitFor(format predicateFormat: String, timeout: TimeInterval = 5.0) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: predicateFormat), object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

final class iOSComboBoxUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //po print(app.debugDescription)!!!!!!!!
    func test_the_comboBox_has_text_equal_to_selected_in_the_dropDown() throws {
        let app = XCUIApplication()
        app.launch()
        app.staticTexts["Enter text here"].tap()
        
        let comboItem4 = app.staticTexts.matching(identifier: "Item 4").firstMatch
        XCTAssertTrue(comboItem4.waitForExistence(timeout: 5.0))
        comboItem4.tap()
        
        let textField = app.textFields["Enter text here"]
        XCTAssertEqual(textField.value as? String, "Item 4")
    }
    
    //po print(app.debugDescription)!!!!!!!!
    func test_dropdown_items_are_visible_after_scrolling_comboBox() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollUpButton = app.buttons["Scroll up"]
        XCTAssert(scrollUpButton.exists)
        scrollUpButton.tap()
        
        app.staticTexts["Enter text here"].tap()
        
        let comboItem4 = app.staticTexts.matching(identifier: "Item 4").firstMatch
        XCTAssert(comboItem4.waitFor(format: "exists == true"))
    }
    
    func test_dropDown_items_are_visible_when_comboBox_at_the_top_of_the_screen_is_tapped() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["TopComboBox"].tap()

        let topDropDownItem = app.staticTexts.matching(identifier: "Poland").firstMatch
        XCTAssertTrue(topDropDownItem.waitForExistence(timeout: 5.0))
        XCTAssertTrue(topDropDownItem.isHittable)
        
        let bottomDropDownItem = app.staticTexts.matching(identifier: "China").firstMatch
        XCTAssertTrue(bottomDropDownItem.waitForExistence(timeout: 5.0))
        XCTAssertTrue(bottomDropDownItem.isHittable)
    }
    
    func test_dropDown_items_are_visible_when_comboBox_at_the_bottom_of_the_screen_is_tapped() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["BottomComboBox"].tap()
        
        let topDropDownItem = app.staticTexts.matching(identifier: "Poland").firstMatch
        XCTAssertTrue(topDropDownItem.waitForExistence(timeout: 5.0))
        XCTAssertTrue(topDropDownItem.isHittable)
        
        let bottomDropDownItem = app.staticTexts.matching(identifier: "China").firstMatch
        XCTAssertTrue(bottomDropDownItem.waitForExistence(timeout: 5.0))
        XCTAssertTrue(bottomDropDownItem.isHittable)
    }

    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    */
}
