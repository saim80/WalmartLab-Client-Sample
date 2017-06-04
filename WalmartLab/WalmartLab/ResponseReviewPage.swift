//
//  ResponseReviewPage.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseReviewPage : ResponseBase {
    var itemId : Int {
        return self.dictionary["itemId"] as? Int ?? 0
    }

    var name : String {
        return self.dictionary["name"] as? String ?? ""
    }

    var salePrice : Double {
        return self.dictionary["salePrice"] as? Double ?? 0.0
    }

    var upc : String {
        return self.dictionary["upc"] as? String ?? ""
    }

    var categoryPath : String {
        return self.dictionary["categoryPath"] as? String ?? ""
    }

    var brandName : String {
        return self.dictionary["brandName"] as? String ?? ""
    }

    var productTrackingUrl : URL? {
        return URL(string:self.dictionary["productTrackingUrl"] as? String ?? "")
    }

    var productUrl : URL? {
        return URL(string:self.dictionary["productUrl"] as? String ?? "")
    }

    var categoryNode : String {
        return self.dictionary["categoryNode"] as? String ?? ""
    }

    var availableOnline : Bool {
        return self.dictionary["availableOnline"] as? Bool ?? false
    }

    var reviewStatistics : ResponseReviewStatistics? {
        return _reviewStatistics
    }

    private var _reviewStatistics : ResponseReviewStatistics?

    var reviews : [ResponseReview] {
        return _reviews
    }

    private var _reviews = [ResponseReview]()

    required init(data: Any) throws {
        try super.init(data: data)

        _reviewStatistics = try ResponseReviewStatistics(data: self.dictionary["reviewStatistics"] ?? [:])
        _reviews = try buildArray(data: self.dictionary["reviews"])
    }
}

class ResponseReviewStatistics : ResponseBase {
    var averageOverallRating : String {
        return self.dictionary["averageOverallRating"] as? String ?? ""
    }

    var overallRatingRange : String {
        return self.dictionary["overallRatingRange"] as? String ?? ""
    }

    var ratingDistributions : [ResponseRatingDistribution] {
        return _ratingDistributions
    }

    private var _ratingDistributions = [ResponseRatingDistribution]()

    var totalReviewCount : String {
        return self.dictionary["totalReviewCount"] as? String ?? ""
    }

    required init(data: Any) throws {
        try super.init(data: data)

        _ratingDistributions = try buildArray(data: self.dictionary["ratingDistributions"])
    }
}

class ResponseRatingDistribution : ResponseBase {
    var count : String {
        return self.dictionary["count"] as? String ?? ""
    }

    var ratingValue : String {
        return self.dictionary["ratingValue"] as? String ?? ""
    }
}

class ResponseReview : ResponseBase {
    var name : String {
        return self.dictionary["name"] as? String ?? ""
    }

    var overallRating : ResponseReviewRating? {
        return _overallRating
    }

    private var _overallRating : ResponseReviewRating?

    var reviewer : String {
        return self.dictionary["reviewer"] as? String ?? ""
    }

    var reviewText : String {
        return self.dictionary["reviewText"] as? String ?? ""
    }

    var submissionTime : String {
        return self.dictionary["submissionTime"] as? String ?? ""
    }

    var title : String {
        return self.dictionary["title"] as? String ?? ""
    }

    var upVotes : String {
        return self.dictionary["upVotes"] as? String ?? ""
    }

    var downVotes : String {
        return self.dictionary["downVotes"] as? String ?? ""
    }

    required init(data: Any) throws {
        try super.init(data: data)

        _overallRating = try ResponseReviewRating(data: self.dictionary["overallRating"] ?? [:])
    }
}

class ResponseReviewRating : ResponseBase {
    var label : String {
        return self.dictionary["label"] as? String ?? ""
    }

    var rating : String {
        return self.dictionary["rating"] as? String ?? ""
    }
}
