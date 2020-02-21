//
//  URLSession+.swift
//  Sky
//
//  Created by tongyi on 2/14/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
