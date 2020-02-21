//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by tongyi on 2/14/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}
