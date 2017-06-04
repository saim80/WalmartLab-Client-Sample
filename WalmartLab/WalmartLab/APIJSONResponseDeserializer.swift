//
//  APIJSONResponseDeserializer.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

/// APIJSONResponseDeserializer converts JSON data into native objects.
///
/// NOTE: In this sample app, we will provide only JSON deserialization for demonstration purposes.
/// but any kind of deserialization method can be created. And, as long as it provides the common
/// interface, it can be plugged into APIEndpoint and APIService instances.
class APIJSONResponseDeserializer : NSObject, APIResponseDeserializer {
    // See the detail in APIResponseDeserializer.
    func deserialize<ReturnType>(data:Data?) throws -> ReturnType? {
        guard let data = data else { return nil }

        return (try JSONSerialization.jsonObject(with: data, options: [])) as? ReturnType
    }
}
