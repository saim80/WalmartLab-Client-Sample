//
//  APIInvocationQueue.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class APIInvocationQueue : NSObject {
    static let shared = APIInvocationQueue()

    var operationQueue = OperationQueue()

    override init() {
        super.init()

        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = .userInitiated
        operationQueue.name = "com.walmartlab.api-invocation-queue"
    }
}
