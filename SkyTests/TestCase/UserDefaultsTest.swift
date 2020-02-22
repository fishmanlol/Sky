//
//  UserDefaultsTest.swift
//  SkyTests
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest
@testable import Sky

class UserDefaultsTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_addLocation() {
        let newLocation = Location(name: "Home", latitude: 52, longitude: 100)
        UserDefaults.add(location: newLocation)
        XCTAssertEqual(UserDefaults.locations.count, 1)
        UserDefaults.remove(location: newLocation)
    }
}
