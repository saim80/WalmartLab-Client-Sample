//
//  ProductsEndpoint.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

class ProductsEndpoint : APIEndpoint<[String:Any], ResponseProductPage>  {
    // XXX: this is weird to have these dynamic parameters as path component.
    //
    // Although it is a requirment to put this info in here, we should consider setting 
    // frequently changing and invocation level states to query string, not to path.
    var pageSize = 10
    var pageNumber = 1

    override var path: String {
        return "walmartproducts/\(WalmartLabTestService.Constants.apiKey)/\(pageNumber)/\(pageSize)"
    }
}
