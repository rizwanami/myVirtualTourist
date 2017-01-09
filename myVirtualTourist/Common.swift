//
//  Common.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/8/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation

struct selection {
    var selectedPin : Pin
    var test : String
}

class Common {
    static let shared = Common()
    var currentPin : Pin?
}
