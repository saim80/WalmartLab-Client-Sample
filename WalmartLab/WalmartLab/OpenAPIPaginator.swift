//
//  OpenAPIPaginator.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

protocol OpenAPIPaginatorDelegate : NSObjectProtocol {
    func paginator(_ paginator:OpenAPIPaginator, didRequestPageWithStart start:Int)
}

class OpenAPIPaginator : NSObject {
    var totalResults = 0
    var start = 0
    var numItems = 0
    var lastPageStart = 1

    weak var scrollView : UIScrollView?
    weak var delegate : OpenAPIPaginatorDelegate?

    func reset() {
        totalResults = 0
        start = 0
        numItems = 0
        lastPageStart = 1
    }

    func set(page:ResponsePage) {
        totalResults = page.totalResults
        start = page.start
        numItems = page.numItems
    }

    var nextStart : Int? {
        guard needsToAppendNewPage else { return nil }

        if start == 0 {
            return 1
        }

        if totalResults < start + numItems {
            return nil
        }

        return start + numItems
    }

    var needsToAppendNewPage : Bool {
        guard let scrollView = scrollView else { return false }

        return lastPageStart == start && scrollView.contentSize.height - (scrollView.frame.height * 3) < scrollView.contentOffset.y
    }

    func loadNextPageIfNecessary() {
        if let start = nextStart {
            self.delegate?.paginator(self, didRequestPageWithStart: start)
            lastPageStart = start
        }
    }
}
