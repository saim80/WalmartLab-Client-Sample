//
//  ResponseProduct.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ResponseProduct : ResponseBase {
    override var primaryKey: String {
        return "productId"
    }

    var productId : String {
        return self.dictionary["productId"] as? String ?? ""
    }

    var productName : String {
        return self.dictionary["productName"] as? String ?? ""
    }

    var shortDescription : String {
        return self.dictionary["shortDescription"] as? String ?? ""
    }

    var longDescription : String {
        return self.dictionary["longDescription"] as? String ?? ""
    }

    var price : String {
        return self.dictionary["price"] as? String ?? ""
    }

    var productImage : URL? {
        return URL(string:self.dictionary["productImage"] as? String ?? "")
    }

    var reviewRating : Float {
        return self.dictionary["reviewRating"] as? Float ?? 0
    }

    var reviewCount : Int {
        return self.dictionary["reviewCount"] as? Int ?? 0
    }

    var inStock : Bool {
        return self.dictionary["inStock"] as? Bool ?? false
    }

    var inStockMessage : NSAttributedString {
        var outString = NSAttributedString()

        if inStock {
            outString = NSAttributedString(string: NSLocalizedString("In stock", comment: #file),
                                           attributes: [NSForegroundColorAttributeName : UIColor.black])
        } else {
            outString = NSAttributedString(string: NSLocalizedString("Out of stock", comment: #file),
                                           attributes: [NSForegroundColorAttributeName : UIColor.gray])
        }

        return outString
    }

    var ratingText : String {
        return String(format:NSLocalizedString("Rating: %.01f", comment: #file),reviewRating)
    }

    var reviewCountText : String {
        return "(\(reviewCount))"
    }
}
