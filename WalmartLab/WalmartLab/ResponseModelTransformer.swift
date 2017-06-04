//
//  DataTransformer.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

protocol ResponseModelTransformer : NSObjectProtocol {
    func transform<ResultType:ResponseModel>(data:Any) throws -> ResultType
}
