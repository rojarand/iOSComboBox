//
//  UIComboBoxUITests.swift
//  UIComboBoxUITests
//
//  Created by Robert Andrzejczyk on 15/03/2024.
//

import XCTest

@testable import UIComboBox


extension XCUIElement {
    func waitFor(format predicateFormat: String, timeout: TimeInterval = 5.0) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: predicateFormat), object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}

private extension XCUIApplication {
    func expandDropDownWithItems() {
        staticTexts["Enter text here"].tap()
    }
}

final class UIComboBoxUITests: XCTestCase {

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
    func testComboBoxHasTextEqualToSelectedInDropDown() throws {
        let app = XCUIApplication()
        app.launch()
        app.expandDropDownWithItems()
        
        let comboItem4 = app.staticTexts.matching(identifier: "Item 4").firstMatch
        XCTAssertTrue(comboItem4.waitForExistence(timeout: 5.0))
        comboItem4.tap()
        
        let textField = app.textFields["Enter text here"]
        XCTAssertEqual(textField.value as? String, "Item 4")
    }
    
    func testDropDownItemsShowWhenComboBoxIsTapped() throws {
        let app = XCUIApplication()
        app.launch()
        app.expandDropDownWithItems()
        
        let comboItem = app.staticTexts.matching(identifier: "Item 1").firstMatch
        XCTAssert(comboItem.waitFor(format: "exists == true"), "The combo did not appear.")
    }
    
    func testComboBoxHidesWhenParentTableScrolls() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollUpButton = app.buttons["Wait & scroll up"]
        XCTAssert(scrollUpButton.exists)
        scrollUpButton.tap()
        
        app.expandDropDownWithItems()
        
        let comboItem = app.staticTexts.matching(identifier: "Item 1").firstMatch
        XCTAssert(comboItem.waitFor(format: "exists == false"), "The combo did not hide.")
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
