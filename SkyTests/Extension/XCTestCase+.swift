//
//  XCTestCase+.swift
//  SkyTests
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import XCTest
import Foundation

extension XCTestCase {
    func loadDataFromBundle(ofName name: String, withExtenison ext: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: name, withExtension: ext)!
        
        return  try! Data(contentsOf: url)
    }
}
