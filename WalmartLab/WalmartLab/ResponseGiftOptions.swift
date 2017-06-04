//
//  ResponseGiftOptions.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseGiftOptions : ResponseBase {

    var allowGiftWrap : Bool {
        return self.dictionary["allowGiftWrap"] as? Bool ?? false
    }

    var allowGiftMessage : Bool {
        return self.dictionary["allowGiftMessage"] as? Bool ?? false
    }

    var allowGiftReceipt : Bool {
        return self.dictionary["allowGifReceipt"] as? Bool ?? false
    }

    required init(data: Any) throws {
        try super.init(data: data)
    }
}
