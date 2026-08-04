//
//  AbsenceReportUITests.swift
//  AbsenceReportUITests
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import XCTest

final class AbsenceReportUITests: XCTestCase {
    
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        app.launch()
        
        return app
    }
    
    
    func test_absenceList_populates() {
        let app = launchApp()
        
        let list = app.collectionViews["absenceList"]
        
        XCTAssertTrue(
            list.waitForExistence(timeout: 5)
        )
        
        let rows = list.cells
        
        XCTAssertEqual(
            rows.count,
            4
        )
    }
    
    func test_sorting_changesOrder() {
        let app = launchApp()
        
        let list = app.collectionViews["absenceList"]
        
        XCTAssertTrue(
            list.waitForExistence(timeout: 5)
        )
        
        let firstRowBefore = list.buttons.element(boundBy: 0).label
        app.buttons["sortButton"].tap()
        
        let sortOption = app.buttons["Start date (latest first)"]
        
        XCTAssertTrue(
            sortOption.waitForExistence(timeout: 3)
        )
        
        sortOption.tap()
        
        let firstRowAfter = list.buttons.element(boundBy: 0).label
        
        XCTAssertNotEqual(
            firstRowBefore,
            firstRowAfter
        )
    }
    
    func test_conflictBadge_isDisplayed() {
        let app = launchApp()
        
        XCTAssertTrue(
            app.staticTexts["Conflict"]
                .waitForExistence(timeout: 5)
        )
    }
}
