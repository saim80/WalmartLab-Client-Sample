//
//  ResponseSearchResult.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/28/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseSearchResultPage : ResponsePage {
    var query : String {
        return self.dictionary["query"] as? String ?? ""
    }

    var sort : String {
        return self.dictionary["sort"] as? String ?? ""
    }

    var responseGroup : String {
        return self.dictionary["responseGroup"] as? String ?? ""
    }

    var items : [ResponseItem] {
        return _items
    }

    private var _items = [ResponseItem]()

    override var primaryKey: String {
        return "query"
    }

    required init(data: Any) throws {
        try super.init(data: data)

        _items = try buildArray(data: self.dictionary["items"])
    }
}
