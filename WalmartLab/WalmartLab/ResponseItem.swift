//
//  ResponseItem.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/28/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseItem : ResponseImageURLs {
    var itemId : Int {
        return self.dictionary["itemId"] as? Int ?? 0
    }

    var parentItemId : Int {
        return self.dictionary["parentItemId"] as? Int ?? 0
    }

    var name : String {
        return self.dictionary["name"] as? String ?? ""
    }

    var msrp : Double {
        return self.dictionary["msrp"] as? Double ?? 0.0
    }

    var salePrice : Double {
        return self.dictionary["salePrice"] as? Double ?? 0.0
    }

    var categoryPath : String {
        return self.dictionary["categoryPath"] as? String ?? ""
    }

    var shortDescription : String {
        return self.dictionary["shortDescription"] as? String ?? ""
    }

    var longDescription : URL? {
        return URL(string:self.dictionary["longDescription"] as? String ?? "")
    }

    var productTrackingUrl : String {
        return self.dictionary["productTrackingUrl"] as? String ?? ""
    }

    var standardShipRate : Double {
        return self.dictionary["standardShipRate"] as? Double ?? 0.0
    }

    var marketplace : Bool {
        return self.dictionary["marketplace"] as? Bool ?? false
    }

    var modelNumber : String {
        return self.dictionary["modelNumber"] as? String ?? ""
    }

    var productUrl : URL? {
        return URL(string:self.dictionary["productUrl"] as? String ?? "")
    }

    var customerRating : String {
        return self.dictionary["customerRating"] as? String ?? ""
    }

    var numReviews : Int {
        return self.dictionary["numReviews"] as? Int ?? 0
    }

    var customerRatingImage : URL? {
        return URL(string:self.dictionary["customerRatingImage"] as? String ?? "")
    }

    var categoryNode : String {
        return self.dictionary["categoruNode"] as? String ?? ""
    }

    var bundle : Bool {
        return self.dictionary["bundle"] as? Bool ?? false
    }

    var stock : String {
        return self.dictionary["stock"] as? String ?? ""
    }

    var addToCartUrl : URL? {
        return URL(string:self.dictionary["addToCartUrl"] as? String ?? "")
    }

    var affiliateAddToCartUrl : URL? {
        return URL(string: self.dictionary["affiliateAddToCartUrl"] as? String ?? "")
    }

    var giftOptions : ResponseGiftOptions

    var imageEntities = [String:[ResponseImageEntity]]()

    var offerType : String {
        return self.dictionary["offerType"] as? String ?? ""
    }

    var isTwoDayShippingEligible : Bool {
        return self.dictionary["isTwoDayShippingEligible"] as? Bool ?? false
    }

    var availableOnline : Bool {
        return self.dictionary["availableOnline"] as? Bool ?? false
    }

    required init(data: Any) throws {
        giftOptions = try ResponseGiftOptions(data: [:])

        try super.init(data: data)

        if let giftOptionsData = self.dictionary["giftOptions"] as? [String:Any] {
            giftOptions = try ResponseGiftOptions(data: giftOptionsData)
        }

        let _imageEntities : [ResponseImageEntity] = try buildArray(data: self.dictionary["imageEntities"])

        for entity in _imageEntities {
            var currentArray = imageEntities[entity.entityType] ?? []

            currentArray.append(entity)

            imageEntities[entity.entityType] = currentArray
        }
    }
}
