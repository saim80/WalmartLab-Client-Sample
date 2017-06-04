//
//  ProductListView.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/4/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductListView : ProductView {

    @IBOutlet var viewWidth : NSLayoutConstraint!
    @IBOutlet var itemDescriptionTopSpacing : NSLayoutConstraint!

    weak var sizeCache : CellSizeCache?

    var indexPath : IndexPath?

    override func finalizeItemSet() {
        if let _ = item {
            if (self.itemDescriptionLabel?.text ?? "").characters.count == 0 {
                itemDescriptionTopSpacing.constant = 0
            } else {
                itemDescriptionTopSpacing.constant = 10
            }
        }

        super.finalizeItemSet()
    }

    override func didLoadProductImage() {
        viewWidth.constant = superview?.bounds.width ?? 0

        // resize the product cell.
        if let indexPath = indexPath, let _ = superview {
            if sizeCache?.cache[indexPath] == nil {
                self.sizeCache?.cacheSize(forView: self, indexPath:indexPath)
            }
        }
    }
}

