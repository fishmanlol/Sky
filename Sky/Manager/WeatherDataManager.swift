//
//  WeatherDataManager.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DarkSkyURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return DarkSkyURLSessionDataTask(request: request, completion: completionHandler)
    }
}

class DarkSkyURLSessionDataTask: URLSessionDataTaskProtocol {
    private let request: URLRequest
    private let completion: DataTaskHandler
    
    init(request: URLRequest, completion: @escaping DataTaskHandler) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        if let json = ProcessInfo.processInfo.environment["FakeJSON"] {
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            let data = json.data(using: .utf8)
            completion(data, response, nil)
        }
    }
}

struct Config {
    private static func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    static var urlSession: URLSessionProtocol = {
        return isUITesting()
            ? DarkSkyURLSession() as URLSessionProtocol
            : URLSession.shared as URLSessionProtocol
    }()
}

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unkown
}

final class WeatherDataManager {
    internal let baseURL: URL
    internal let urlSession: URLSessionProtocol
    internal let MAX_ATTEMPTS = 3
    internal init(baseURL: URL, urlSession: URLSessionProtocol) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL, urlSession: Config.urlSession)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    func weatherDataAt(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        return (urlSession as! URLSession)
            .rx
            .data(request: request)
            .map { try WeatherData.decodeJSONFrom($0) }
            .retryWhen({ (rxError) -> Observable<Int> in
                return rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
                    if index < self.MAX_ATTEMPTS {
                        print("Fetch weather data failed, this is the \(index + 1) time")
                    
                        return Observable<Int>.timer(.seconds(index + 1), scheduler: MainScheduler.instance)
                    } else {
                        print("Fetch weather data failed, no retry anymore")
                        
                        return Observable.error(error)
                    }
                }
            })
            .do(onNext: {
                print($0)
            })
            .catchErrorJustReturn(WeatherData.invalid)
    }
}
