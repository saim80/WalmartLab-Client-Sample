//
//  ProductDetailView.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductView : UIView {
    @IBOutlet var itemImageView : UIImageView?
    @IBOutlet var itemTitleLabel : UILabel?
    @IBOutlet var itemPrice : UILabel?
    @IBOutlet var itemDescriptionLabel : UILabel?
    @IBOutlet var itemRatingLabel : UILabel?
    @IBOutlet var itemNumReviewsLabel : UILabel?
    @IBOutlet var itemInStock : UILabel?

    func didLoadProductImage() {

    }

    var item : ResponseProduct? {
        willSet {
            prepareItemSet()
        }

        didSet {
            finalizeItemSet()
        }
    }

    func prepareItemSet() {
        itemImageView?.image = nil
        itemTitleLabel?.text = nil
        itemPrice?.text = nil
        itemDescriptionLabel?.text = nil
        itemRatingLabel?.text = nil
        itemNumReviewsLabel?.text = nil
        itemInStock?.text = nil
    }

    func finalizeItemSet() {
        if let item = item {
            self.itemTitleLabel?.text = item.productName
            self.itemPrice?.text = item.price

            self.itemDescriptionLabel?.text = item.longDescription.unescapedHTML.stripHTML
            self.itemRatingLabel?.text = item.ratingText
            self.itemNumReviewsLabel?.text = item.reviewCountText
            self.itemInStock?.attributedText = item.inStockMessage

            if let imageURL = item.productImage {
                ImageCache.shared.loadImage(imageURL: imageURL, block: { [weak self] (image:UIImage?, error:Error?) in
                    guard let strongSelf = self else { return }

                    if strongSelf.item == item {
                        strongSelf.itemImageView?.image = image
                    }

                    strongSelf.didLoadProductImage()
                })
            }
        }
    }
}
