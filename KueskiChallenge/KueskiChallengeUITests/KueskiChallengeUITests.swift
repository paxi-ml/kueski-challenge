//
//  KueskiChallengeUITests.swift
//  KueskiChallengeUITests
//
//  Created by Alexander Coto on 7/3/24.
//

import XCTest

final class KueskiChallengeUITests: XCTestCase {
    var app:XCUIApplication = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testCollectionViewLoading() throws {
        assert(app.segmentedControls.firstMatch.waitForExistence(timeout: 5.0), "Grid/table selector not showing")
        app.segmentedControls.buttons["squareshape.split.3x3"].tap()
        assert(app.collectionViews.firstMatch.waitForExistence(timeout: 5.0), "Grid never loaded")
        let collectionView = app.collectionViews.firstMatch
        assert(collectionView.cells.firstMatch.waitForExistence(timeout: 5.0), "Grid cells never loaded")
        
        // We could do something lile this calculating screen height / cell height and check that screen is filled, but not much use right now, just wanted to show is a possibility.
        //assert(collectionView.cells.count == 6, "Not all initially visible grid cells loaded correctly")
        
        // Or we can get creative and just count the cells and scroll to the bottom.
        var scrolls = 0
        var allCells:[String] = []
        var cellCount = -1
        while (cellCount != allCells.count) {
            cellCount = allCells.count
            var cellIndex = 0
            while (collectionView.cells.element(boundBy: cellIndex).exists) {
                let cell = collectionView.cells.element(boundBy: cellIndex)
                let title = cell.staticTexts.element(boundBy: 4)
                if (!allCells.contains(title.label)) {
                    allCells.append(title.label)
                }
                cellIndex = cellIndex + 1
            }
            app.swipeUp()
            scrolls = scrolls + 1
            if (scrolls > 5) {
                break
            }
        }
        assert(cellCount > 20, "Pagination not working correctly in grid")
    }
    
    func testTableViewLoading() throws {
        assert(app.segmentedControls.firstMatch.waitForExistence(timeout: 5.0), "Grid/table selector not showing")
        app.segmentedControls.buttons["list.star"].tap()
        assert(app.tables.firstMatch.waitForExistence(timeout: 5.0), "Table never loaded")
        let tableView = app.tables.firstMatch
        assert(tableView.cells.firstMatch.waitForExistence(timeout: 5.0), "Table cells never loaded")
        //Same here
        //assert(tableView.cells.count == 20, "Not all table cells loaded correctly")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
