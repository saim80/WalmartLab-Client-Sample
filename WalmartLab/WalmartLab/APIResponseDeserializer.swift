//
//  APIResponseDeserializer.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

/// APIResponseDeserializer provides a common interface for deserializing api endpoint
/// responses. The interface is used for APIEndpoint to convert raw response bodies into
/// native objects.
///
/// You can plug this instance into APIService as default deserialization method.
/// Or, you can plug this instance into APIEndpoint as endpoint specific deserialization method.
protocol APIResponseDeserializer : NSObjectProtocol {
    /// For given data object, this method returns native objects by deserializing the raw api response body.
    ///
    /// @param data Data to be deserialized.
    /// @return The native object deserialized from the given data.
    func deserialize<ReturnType>(data:Data?) throws -> ReturnType?
}
