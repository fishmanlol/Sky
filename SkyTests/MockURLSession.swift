//
//  MockURLSession.swift
//  SkyTests
//
//  Created by tongyi on 2/16/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSession: URLSessionProtocol {
    let sessionDataTask: URLSessionDataTaskProtocol
    var responseData: Data?
    var responseHeader: HTTPURLResponse?
    var responseError: Error?
    
    init(dataTask: URLSessionDataTaskProtocol = MockURLSessionDataTask()) {
        self.sessionDataTask = dataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        completionHandler(responseData, responseHeader, responseError)
        return sessionDataTask
    }
}
