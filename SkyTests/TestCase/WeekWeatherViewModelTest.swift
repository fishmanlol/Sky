//
//  WeekWeatherViewModelTest.swift
//  SkyTests
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest
@testable import Sky

class WeekWeatherViewModelTest: XCTestCase {
    var vm: WeekWeatherViewModel!
    
    override func setUp() {
        super.setUp()
        
        let data = loadDataFromBundle(ofName: "DarkSky", withExtenison: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weather = try! decoder.decode(WeatherData.self, from: data)
        
        vm = WeekWeatherViewModel()
        vm.weatherData = weather.daily.data
    }
    
    override func tearDown() {
        super.tearDown()
        
        vm = nil
    }
    
    func test_numberOfDays() {
        XCTAssertEqual(vm.numberOfDays, 1)
    }
    
    func test_numberOfSections() {
        XCTAssertEqual(vm.numberOfSections, 1)
    }
    
    func test_viewModelForIndex() {
        let weekdayVM = vm.weekdayWeatherViewModel(for: 0)
        XCTAssertEqual(weekdayVM.humidity, "25 %")
    }
}
