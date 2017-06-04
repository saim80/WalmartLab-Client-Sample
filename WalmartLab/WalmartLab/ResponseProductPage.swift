//
//  ResponseProducts.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseProductPage : ResponseBase {
    var products : [ResponseProduct] {
        return _products
    }

    var totalProducts : Int {
        return self.dictionary["totalProducts"] as? Int ?? 0
    }

    var pageNumber : Int {
        return self.dictionary["pageNumber"] as? Int ?? 0
    }

    var pageSize : Int {
        return self.dictionary["pageSize"] as? Int ?? 0
    }

    var status : Int {
        return self.dictionary["status"] as? Int ?? 0
    }

    var kind : String {
        return self.dictionary["kind"] as? String ?? ""
    }

    var etag : String {
        return self.dictionary["etag"] as? String ?? ""
    }

    private var _products = [ResponseProduct]()

    required init(data: Any) throws {
        try super.init(data: data)

        _products = try buildArray(data: self.dictionary["products"] ?? [:])
    }
}
