//
//  APIServiceCenter.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class APIServiceCenter : NSObject {
    static let shared = APIServiceCenter()

    var walmartLab = WalmartLabService()
    var walmartLabTest = WalmartLabTestService()

    override init() {
        super.init()
    }
}
