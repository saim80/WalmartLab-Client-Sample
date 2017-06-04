//
//  APIInvocationQueryFragment.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

/// APIInvocationQueryFragment provides a programming construct to represent API request parameters.
class APIInvocationQueryFragment : NSObject {
    private var stringKey : String
    private var stringValue : String

    var key:CustomStringConvertible {
        return _key
    }
    var value:CustomStringConvertible {
        return _value
    }

    private var _key:CustomStringConvertible
    private var _value:CustomStringConvertible

    init(key:CustomStringConvertible, value:CustomStringConvertible) {
        _key = key
        _value = value
        stringKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        stringValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        super.init()
    }

    var pair : (key:String,value:String) {
        return (key:stringKey, value:stringValue)
    }

    override var description: String {
        return "\(stringKey)=\(stringValue)"
    }
}
