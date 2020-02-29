//
//  CurrentWeatherViewModelTest.swift
//  SkyTests
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest
@testable import Sky

class CurrentWeatherViewModelTest: XCTestCase {
    var vm: CurrentWeatherViewModel!
    
    override func setUp() {
        super.setUp()
        
        let data = loadDataFromBundle(ofName: "DarkSky", withExtenison: "json")
        vm = CurrentWeatherViewModel(weather: try! WeatherData.decodeJSONFrom(data))
        vm.wea
        vm.location = Location(name: "Home", latitude: 52, longitude: 100)
        vm.weather = try! decoder.decode(WeatherData.self, from: data)
    }
    
    override func tearDown() {
        super.tearDown()
        
        vm = nil
        UserDefaults.standard.removeObject(forKey: UserDefaults.dateModeKey)
        UserDefaults.standard.removeObject(forKey: UserDefaults.temperatureModeKey)
    }
    
    func test_city() {
        XCTAssertEqual(vm.city, "Home")
    }
    
    func test_temperature_in_fahrenheit() {
        UserDefaults.temperatureMode = .fahrenheit
        XCTAssertEqual(vm.temperature, "48.5 ℉")
    }
    
    func test_temperature_in_celsius() {
        UserDefaults.temperatureMode = .celsius
        XCTAssertEqual(vm.temperature, "9.2 ℃")
    }
    
    func test_humidity() {
        XCTAssertEqual(vm.humudity, "85.0 %")
    }
    
    func test_summary() {
        XCTAssertEqual(vm.summary, "Mostly Cloudy")
    }
}
