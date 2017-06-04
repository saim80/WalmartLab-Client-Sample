//
//  ResponseImageEntity.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseImageURLs : ResponseBase {
    var thumbnailImage : URL? {
        return URL(string:self.dictionary["thumbnailImage"] as? String ?? "")
    }

    var mediumImage : URL? {
        return URL(string:self.dictionary["mediumImage"] as? String ?? "")
    }

    var largeImage : URL? {
        return URL(string:self.dictionary["largeImage"] as? String ?? "")
    }

    var bestImage : URL? {
        if largeImage != nil {
            return largeImage
        }
        if mediumImage != nil {
            return mediumImage
        }
        return thumbnailImage
    }
}

class ResponseImageEntity : ResponseImageURLs {
    var entityType : String {
        return self.dictionary["entityType"] as? String ?? ""
    }
}
