//
//  APIEndpoint.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

/// APIEndpoint represents a Rest API call path
/// Subclass this class for your own api calls. Then, simply add the end point to the target APIService instance.
class APIEndpoint<ResponseType, ModelType:ResponseModel> : NSObject, ResponseModelTransformer {
    weak var service : APIService? {
        return _service
    }

    enum Version : String, CustomStringConvertible {
        case v1 = "v1"

        var description: String {
            return self.rawValue
        }
    }

    enum ResponseFormat : String, CustomStringConvertible {
        case json = "json"

        var description: String {
            return self.rawValue
        }
    }

    private weak var _service : APIService?
    
    var version = Version.v1

    var path : String {
        return ""
    }

    var queryFragments = Set<APIInvocationQueryFragment>()

    var deserializer : APIResponseDeserializer? {
        set {
            _deserialzier = newValue
        }
        get {
            if _deserialzier == nil {
                return _service?.deserializer
            }
            return _deserialzier
        }
    }

    private var _deserialzier : APIResponseDeserializer?

    init(service:APIService) {
        _service = service
        super.init()
    }

    var invocation : APIInvocation<ResponseType, ModelType>?

    func cancel() {
        invocation?.cancel()
    }

    func call(parameters:Set<APIInvocationQueryFragment>, success:APIInvocationResult<ResponseType, ModelType>?, failure:APIInvocationResult<ResponseType, ModelType>?) {
        guard let service = service else {
            DispatchQueue.main.async {
                failure?(nil)
            }
            return
        }

        cancel()
        invocation = APIInvocation<ResponseType, ModelType>(endPoint: self)

        for param in parameters {
            invocation?.query.fragments.insert(param)
        }

        for param in queryFragments {
            invocation?.query.fragments.insert(param)
        }

        for param in service.queryFragments {
            invocation?.query.fragments.insert(param)
        }

        precondition(self.deserializer is APIJSONResponseDeserializer, "We do not support XML response format yet.")

        invocation?.query.fragments.insert(APIInvocationQueryFragment(key: "format", value: ResponseFormat.json))


        invocation?.submit(success: success, failure: failure)
    }

    func transform<ResultType:ResponseModel>(data: Any) throws -> ResultType {
        return try ResultType(data: data)
    }
}
