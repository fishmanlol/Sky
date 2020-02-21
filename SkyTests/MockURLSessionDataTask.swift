//
//  MockURLSessionDataTask.swift
//  SkyTests
//
//  Created by tongyi on 2/16/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var isResumeCalled = false
    func resume() {
        isResumeCalled = true
    }
}
