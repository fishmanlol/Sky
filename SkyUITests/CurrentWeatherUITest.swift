//
//  CurrentWeatherUITest.swift
//  SkyUITests
//
//  Created by tongyi on 2/17/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest

class CurrentWeatherUITest: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["FakeJSON"] = """
        {
            "latitude": 52,
            "longitude": 100,
            "currently": {
                "time": 1581665677,
                "summary": "Mostly Cloudy",
                "icon": "partly-cloudy-night",
                "temperature": 48.54,
                "humidity": 0.85,
            }
        }
        """
        app.launch()
   }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_location_button_exists() {
        let locationBtn = app.buttons["LocationBtn"]
//        let exists = NSPredicate(format: "exists == true")
//
//        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
//
//        waitForExpectations(timeout: 15, handler: nil)
        
        XCTAssert(locationBtn.exists)
    }
}
