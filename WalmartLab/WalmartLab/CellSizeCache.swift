//
//  CellSizeCache.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

protocol CellSizeCacheDelegate : NSObjectProtocol {
    func cellSizeCache(_ cellSizeCache:CellSizeCache, didUpdateHeight height:CGFloat, indexPath:IndexPath)
}

class CellSizeCache : NSObject {
    var cache = [IndexPath:CGFloat]()

    var defaultHeight = CGFloat(250)

    weak var delegate : CellSizeCacheDelegate?

    func cacheSize(forView view:UIView, indexPath:IndexPath) {
        if let container = view.superview {

            let previousValue = cache[indexPath] ?? 0

            cache[indexPath] = round(view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)

            if previousValue != cache[indexPath] {
                DispatchQueue.main.async {
                    self.delegate?.cellSizeCache(self, didUpdateHeight: self.cache[indexPath] ?? self.defaultHeight, indexPath: indexPath)
                }
            }

            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = container.bounds
        }
    }
}
