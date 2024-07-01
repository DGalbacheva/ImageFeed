//
//  ImageFeedUITests.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import XCTest

class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UITEST"]
        
        app.launch()
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        sleep(3)
        app.buttons["Authenticate"].tap()
        
        sleep(3)
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        sleep(5)
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        sleep(5)
        loginTextField.tap()
        loginTextField.typeText("galbachevva@gmail.com")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        sleep(5)
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("#Doroteya13")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        let tablesQuery = app.tables
        sleep(3)
        tablesQuery.element.swipeUp()
        
        let cellLike = tablesQuery.cells.firstMatch
        let likeButton = cellLike.buttons["LikeButton"]
        likeButton.tap()
        sleep(2)
        likeButton.tap()
        sleep(2)
        
        cellLike.tap()
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Doroteya Galbacheva"].exists)
        XCTAssertTrue(app.staticTexts["@doroteyag"].exists)
        sleep(3)
        app.buttons["logout button"].tap()
        sleep(3)
        //let alert = app.alerts["Пока, пока!"]
        //XCTAssertTrue(alert.exists, "Error: no alert")
        //alert.buttons["Да"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
