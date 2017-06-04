//
//  TestAPIPaginator.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

protocol TestAPIPaginatorDelegate : NSObjectProtocol {
    func paginator(_ paginator:TestAPIPaginator, didRequestPageWithStart start:Int)
}

class TestAPIPaginator : NSObject {
    var totalResults = 0
    var start = 0
    var numItems = 0
    var lastPageStart = 1

    weak var scrollView : UIScrollView?
    weak var delegate : TestAPIPaginatorDelegate?

    func reset() {
        totalResults = 0
        start = 0
        numItems = 0
        lastPageStart = 1
    }

    func set(page:ResponseProductPage) {
        totalResults = page.totalProducts
        start = 1 + max(0, page.pageNumber - 1) * numItems
        numItems = page.products.count
    }

    var nextStart : Int? {
        guard needsToAppendNewPage else { return nil }

        if start == 0 {
            return 1
        }

        if isAtEnd {
            return nil
        }

        return start + numItems
    }

    var needsToAppendNewPage : Bool {
        guard let scrollView = scrollView else { return false }

        return lastPageStart == start && scrollView.contentSize.height - (scrollView.frame.height * 3) < scrollView.contentOffset.y
    }

    var isAtEnd : Bool {
        return totalResults <= start + numItems
    }

    func loadNextPageIfNecessary(currentItemNumber:Int? = nil) {
        if let currentItemNumber = currentItemNumber {
            if currentItemNumber - start > numItems * 2 / 3 {
                _loadNextPageIfNecessary()
            }
        }
    }

    private func _loadNextPageIfNecessary() {
        if let start = nextStart {
            self.delegate?.paginator(self, didRequestPageWithStart: start)
            lastPageStart = start
        }
    }
}
