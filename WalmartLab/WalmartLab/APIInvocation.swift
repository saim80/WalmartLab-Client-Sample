//
//  APIInvocation.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

typealias APIInvocationResult<ResponseType, ModelType:ResponseModel> = (APIInvocation<ResponseType, ModelType>?)->Void

/// APIInvocation composes the request to invoke the backend API.
/// The instance is not re-usuable. Once used for an invocation, you should discard and create another
/// instance if you intend to invoke the same API call.
/// You shouldn't be instantiating this class by youself. APIEndpoint class usually create this instance 
/// for you.
class APIInvocation<ResponseType, ModelType:ResponseModel> : NSObject {
    /// The type of network protocol
    enum NetworkProtocol : String {
        case insecureHTTP = "http://"
        case secureHTTP = "https://"
    }

    /// Backward ref to APIEndpoint which instantiated APIInvocation instance.
    weak var endPoint : APIEndpoint<ResponseType, ModelType>? {
        return _endPoint
    }

    /// Backward ref to APIService which this invocation belongs to
    weak var service : APIService? {
        return _endPoint?.service
    }

    /// Private end point instance. You won't be able to set this value. This value is
    /// set by init(endPoint:APIEndpoint).
    private weak var _endPoint : APIEndpoint<ResponseType, ModelType>?

    /// Set if error occurred during network transaction.
    var error : Error?
    /// Data received from the API endpoint invocation.
    var data : Data?
    /// HTTP status code.
    var statusCode = 0
    /// Network protocol
    var networkProtocol = NetworkProtocol.secureHTTP
    /// URLSessionDataTask which perform HTTP URL loading.
    var dataTask : URLSessionDataTask?
    /// Query instance which contains API endpoint specific query parameters.
    var query = APIInvocationQuery()
    /// Deserialized object from response data.
    var responseObject : ResponseType?
    /// Data model ready for use.
    var dataModel : ModelType?
    /// Post processing operation scheduled.
    var postprocess : Operation?

    var requestURL : URL? {
        guard let endPoint = endPoint else { return nil }
        guard let service = service else { return nil }

        var URLString = "\(networkProtocol.rawValue)\(service.host)/\(endPoint.version)/"

        if endPoint.path.characters.count > 0 {
            URLString.append(endPoint.path)
        }

        if query.fragments.count > 0 {
            URLString.append("?\(query.description)")
        }

        return URL(string:URLString)
    }

    required init(endPoint:APIEndpoint<ResponseType, ModelType>) {
        _endPoint = endPoint
        super.init()
    }

    func cancel() {
        dataTask?.cancel()
        postprocess?.cancel()
    }

    func submit(success:APIInvocationResult<ResponseType, ModelType>?,
                failure:APIInvocationResult<ResponseType, ModelType>?) {
        guard let requestURL = requestURL else {
            DispatchQueue.main.async {
                failure?(self)
            }
            return
        }

        let dataTask = URLSession.shared.dataTask(with: requestURL) { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            guard let strongSelf = self else { failure?(nil); return }
            guard let HTTPResponse = response as? HTTPURLResponse else { failure?(strongSelf); return }

            strongSelf.data = data
            strongSelf.error = error

            strongSelf.postprocess = BlockOperation(block: { [weak self] in
                guard let strongSelf = self else { failure?(nil); return }
                guard let endPoint = strongSelf.endPoint else { failure?(strongSelf); return }

                if !(strongSelf.postprocess?.isCancelled ?? true) {
                    if let deserializer = endPoint.deserializer {
                        do {
                            strongSelf.responseObject = try deserializer.deserialize(data: data)
                            if let response = strongSelf.responseObject {
                                strongSelf.dataModel = try endPoint.transform(data: response)
                            }
                        } catch let error {
                            strongSelf.error = error

                            debugPrint("error occurred while postprocessing: \(error)")
                        }
                    }
                }

                if HTTPResponse.statusCode == 200 &&
                    strongSelf.error       == nil &&
                    !(strongSelf.postprocess?.isCancelled ?? true) {
                    DispatchQueue.main.async {
                        success?(strongSelf)
                    }
                } else {
                    DispatchQueue.main.async {
                        failure?(strongSelf)
                    }
                }
            })

            APIInvocationQueue.shared.operationQueue.addOperation(strongSelf.postprocess!)
        }

        self.dataTask = dataTask

        dataTask.resume()
    }
}
