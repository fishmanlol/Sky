//
//  Codable.swift
//  Sky
//
//  Created by Yi Tong on 2/26/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

extension Decodable {
    static func decodeJSONFrom(_ data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        return try decoder.decode(Self.self, from: data)
    }
}
