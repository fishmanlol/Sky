//
//  GeocoderOperation.swift
//  Sky
//
//  Created by Yi on 2020/2/22.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

class GeocoderOperation: Operation {
    let address: String
    
    init(address: String) {
        self.address = address
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        
    }
}
