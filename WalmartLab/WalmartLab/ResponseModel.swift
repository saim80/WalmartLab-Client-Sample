//
//  ServerResponseModel.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ResponseModel : NSObject {
    open var primaryKey : String {
        return ""
    }

    required init(data:Any) throws {
    }

    override var hash: Int {
        if self.primaryKey.characters.count > 0 {
            if let hashValue = self.value(forKeyPath: "\(self.primaryKey).hash") as? Int {
                return hashValue
            }
        }

        return super.hash
    }
}

class ResponseObject : ResponseModel {
    var dictionary = [String:Any]()

    enum ParseError : Error {
        case invalidData
    }

    required init(data: Any) throws {
        try super.init(data: data)

        if let data = data as? [String:Any] {
            dictionary = data
        } else {
            throw ParseError.invalidData
        }
    }

    func buildArray<ResultType:ResponseObject>(data:Any?) throws -> [ResultType] {
        var outArray = [ResultType]()

        if let objectArray = data as? [[String:Any]] {
            for objectDictionary in objectArray {
                outArray.append(try ResultType(data:objectDictionary))
            }
        }

        return outArray
    }
}

class ResponseBase : ResponseObject {
    var errors : [ResponseError] {
        return _errors
    }
    private var _errors = [ResponseError]()

    required init(data: Any) throws {
        try super.init(data: data)

        _errors = try buildArray(data: self.dictionary["errors"])
    }
}

class ResponseError : ResponseObject {
    var message : String {
        return self.dictionary["message"] as? String ?? ""
    }
    var code : Int {
        return self.dictionary["code"] as? Int ?? 0
    }
}
