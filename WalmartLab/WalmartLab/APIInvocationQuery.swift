//
//  APIInvocationQuery.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class APIInvocationQuery : NSObject {
    var fragments = Set<APIInvocationQueryFragment>()

    var dictionary : [String:String] {
        var outDict = [String:String]()

        for parameter in fragments {
            let pair = parameter.pair
            outDict[pair.key] = pair.value
        }

        return outDict
    }

    override var description: String {
        var outString = fragments.reduce("") { (result:String, param:APIInvocationQueryFragment) -> String in
            if result.characters.count == 0 {
                return param.description
            }

            return "\(result)&\(param)"
        }

        if outString.characters.count == 0 {
            outString = super.description
        }
        
        return outString
    }
}
