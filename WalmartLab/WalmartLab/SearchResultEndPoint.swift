//
//  SearchResultEndPoint.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation


class SearchResultEndPoint : APIEndpoint<[String:Any], ResponseSearchResultPage> {
    override var path: String {
        return "search/"
    }

    enum ParameterKey : String, CustomStringConvertible {
        case query = "query"
        case categoryId = "categoryId"
        case start = "start"

        var description: String {
            return self.rawValue
        }
    }

    var query : String? {
        didSet {
            if query != oldValue {
                if let value = query {
                    _queryFragment = APIInvocationQueryFragment(key: ParameterKey.query, value: value)
                } else {
                    _queryFragment = nil
                }
            }
        }
    }

    var categoryId : Int? {
        didSet {
            if categoryId != oldValue {
                if let value = categoryId {
                    _categoryIdFragment = APIInvocationQueryFragment(key: ParameterKey.categoryId, value:value)
                } else {
                    _categoryIdFragment = nil
                }
            }
        }
    }

    private var _queryFragment : APIInvocationQueryFragment? {
        willSet {
            if let value = _queryFragment {
                queryFragments.remove(value)
            }
        }

        didSet {
            if let value = _queryFragment {
                queryFragments.insert(value)
            }
        }
    }

    private var _categoryIdFragment : APIInvocationQueryFragment? {
        willSet {
            if let value = _categoryIdFragment {
                queryFragments.remove(value)
            }
        }

        didSet {
            if let value = _categoryIdFragment {
                queryFragments.insert(value)
            }
        }
    }
}
