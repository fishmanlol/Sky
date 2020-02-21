//
//  WeatherDataManager.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

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
    internal init(baseURL: URL, urlSession: URLSessionProtocol) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL, urlSession: Config.urlSession)
    
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
    
    func weatherDataAt(latitude: Double,
                       longitude: Double,
                       completion: @escaping CompletionHandler) {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { (data, response, error) in
            self.didFinishGettingWeatherData(data: data,
                                             response: response,
                                             error: error,
                                             completion: completion)
        }.resume()
    }
    
    private func didFinishGettingWeatherData(data: Data?,
                                             response: URLResponse?,
                                             error: Error?,
                                             completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData, nil)
                } catch {
                    completion(nil, .invalidResponse)
                }
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unkown)
        }
    }
}
