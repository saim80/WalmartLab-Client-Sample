//
//  WalmartLabTestService.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class WalmartLabTestService : APIService {
    struct EndPoints {
        static let walmartProducts = "walmartproducts"
    }

    struct Constants {
        static let hostname = "walmartlabs-test.appspot.com/_ah/api/walmart"
        static let apiKey = "142b6009-4255-4711-8710-da8b2aafc00a"
    }

    override var host: String {
        return Constants.hostname
    }

    required init() {
        super.init()

        endPoints[EndPoints.walmartProducts] = ProductsEndpoint(service:self)

        queryFragments.insert(APIInvocationQueryFragment(key: "apiKey", value: Constants.apiKey))
    }
}
