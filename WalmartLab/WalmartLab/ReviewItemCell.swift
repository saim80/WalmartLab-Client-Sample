//
//  ReviewItemCell.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ReviewItemCell : UITableViewCell {
    @IBOutlet weak var itemView : ReviewItemView?
}

class ReviewItemView : UIView {
    @IBOutlet var viewWidth : NSLayoutConstraint!

    weak var sizeCache : CellSizeCache?

    var indexPath : IndexPath?

    @IBOutlet var reviewerLabel : UILabel?
    @IBOutlet var reviewText : UILabel?
    @IBOutlet var reviewTitleLabel : UILabel?

    var item : ResponseReview? {
        willSet {

        }
        
        didSet {
            if let item = item {
                self.reviewerLabel?.text = item.reviewer
                self.reviewText?.text = item.reviewText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.reviewTitleLabel?.text = item.title
                self.viewWidth.constant = superview?.bounds.width ?? 0

                if let indexPath = indexPath, let _ = self.superview {
                    if sizeCache?.cache[indexPath] == nil {
                        sizeCache?.cacheSize(forView: self, indexPath:indexPath)
                    }
                }
            }
        }
    }
}
