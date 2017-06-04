//
//  APIService.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class APIService : NSObject {
    var host : String {
        return ""
    }

    var endPoints = [String:Any]() // due to lack of type covariance in Swift, we have to use Any type here.
    var queryFragments = Set<APIInvocationQueryFragment>()
    var deserializer = APIJSONResponseDeserializer()

    required override init() {
        super.init()
    }
}
