//
//  AuthViewControllerUITest.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 02/03/2017.
//
//
import XCTest
import SimpleKeychain
import OHHTTPStubs

@testable import JitenshaMobile
class AuthViewControllerTest: XCTestCase {

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()

        app.launchArguments = [ "STUB_HTTP_ENDPOINTS" ]

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
    }


    func testLogin() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("crossover@crossover.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Tester123")
        app.buttons["Login"].tap()
        let title = app.descendants(matching: .navigationBar).element.identifier
        XCTAssertEqual(title, "Places")
    }

    func testRegister() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("crossover@crossover.com")
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("Crossover123")
        app.buttons["Register"].tap()
        let title = app.descendants(matching: .navigationBar).element.identifier
        XCTAssertEqual(title, "Places")

    }

}
