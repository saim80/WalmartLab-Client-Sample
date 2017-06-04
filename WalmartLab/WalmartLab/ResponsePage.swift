//
//  ResponsePage.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponsePage : ResponseBase {
    var totalResults : Int {
        return self.dictionary["totalResults"] as? Int ?? 0
    }

    var start : Int {
        return self.dictionary["start"] as? Int ?? 0
    }

    var numItems : Int {
        return self.dictionary["numItems"] as? Int ?? 0
    }
}
