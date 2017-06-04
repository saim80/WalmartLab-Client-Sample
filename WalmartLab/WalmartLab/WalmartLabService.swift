//
//  APIWalmartLabService.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class WalmartLabService : APIService {
    struct EndPoints {
        static let searchResult = "searchResult"
        static let reviews = "reviews"
    }

    struct Constants {
        static let hostname = "api.walmartlabs.com"
        static let apiKey = "akhd5467uue3rqkqwk6rk3b3"
    }
    
    override var host: String {
        return Constants.hostname
    }

    required init() {
        super.init()

        endPoints[EndPoints.searchResult] = SearchResultEndPoint(service:self)
        endPoints[EndPoints.reviews] = ReviewsEndPoint(service: self)

        queryFragments.insert(APIInvocationQueryFragment(key: "apiKey", value: Constants.apiKey))
    }
}
