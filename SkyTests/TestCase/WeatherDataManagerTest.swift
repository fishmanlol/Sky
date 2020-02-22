//
//  WeatherDataManagerTest.swift
//  SkyTests
//
//  Created by tongyi on 2/14/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest
@testable import Sky

class WeatherDataManagerTest: XCTestCase {
    
    var dataTask: MockURLSessionDataTask!
    var session: MockURLSession!
    var manager: WeatherDataManager!

    override func setUp() {
        dataTask = MockURLSessionDataTask()
        session = MockURLSession(dataTask: dataTask)
        manager = WeatherDataManager(baseURL: URL(string: "https://darksky.net")!, urlSession: session)
    }

    override func tearDown() {
        dataTask = nil
        session = nil
        manager = nil
    }
    
    func test_weatherDataAt_start_the_session() {
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, _) in }
        XCTAssert(dataTask.isResumeCalled)
    }
    
    func test_weatherDataAt_gets_data() {
        let expect = expectation(description: "Loading data from \(API.authenticatedURL)")
        var data: WeatherData? = nil
        
        WeatherDataManager.shared.weatherDataAt(latitude: 52, longitude: 100) { (responseData, error) in
            data = responseData
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(data)
    }
    
    func test_weatherDataAt_handle_invalid_request() {
        session.responseError = NSError(domain: "Invalid Request", code: 100, userInfo: nil)
        
        var error: DataManagerError? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in error = e }
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    func test_weatherDataAt_handle_statuscode_note_equal_to_200() {
        session.responseHeader = HTTPURLResponse(url: URL(string: "https://darksky.net")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)
        session.responseData = data
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in error = e }
        
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    func test_weatherDataAt_handle_invalid_response() {
        session.responseHeader = HTTPURLResponse(url: URL(string: "https://darksky.net")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = "{".data(using: .utf8)
        session.responseData = data
        
        var error: DataManagerError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, e) in error = e }
        
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    func test_weatherDataAt_handle_response_decode() {
        session.responseHeader = HTTPURLResponse(url: URL(string: "https://darksky.net")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = loadDataFromBundle(ofName: "DarkSky", withExtenison: "json")
        
        session.responseData = data
        
        var weatherData: WeatherData?
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (data, _) in
            weatherData = data
        }
        
        let expected = WeatherData(latitude: 52,
                                   longitude: 100,
                                   currently: WeatherData.CurrentWeather(time: Date(timeIntervalSince1970: 1581665677),
                                    summary: "Mostly Cloudy",
                                    icon: "partly-cloudy-night",
                                    temperature: 48.54,
                                    humidity: 0.85),
                                   daily: WeatherData.WeekWeatherData(data: [ForecastData(time: Date(timeIntervalSince1970: 1507180335), temperatureLow: 66, temperatureHigh: 82, icon: "clear-day", humidity: 0.25)]))
        
        XCTAssertEqual(weatherData, expected)
    }
}
