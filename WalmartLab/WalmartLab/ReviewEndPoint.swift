//
//  ReviewEndPoint.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ReviewsEndPoint : APIEndpoint<[String:Any], ResponseReviewPage> {
    override var path: String {
        return "reviews/\(itemId)"
    }

    var itemId = 0
}
