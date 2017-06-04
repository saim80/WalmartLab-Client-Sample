//
//  SearchResultItemCell.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

fileprivate var currencyFormatter : NumberFormatter?

extension Double {
    var priceString : String {

        if currencyFormatter == nil {
            currencyFormatter = NumberFormatter()
            currencyFormatter?.locale = Locale.current
            currencyFormatter?.numberStyle = .currency
        }

        return currencyFormatter?.string(from: NSNumber(value:self)) ?? ""
    }
}

class SearchResultItemCell : UITableViewCell {
    @IBOutlet weak var itemView : SearchResultItemView?
}

class SearchResultItemView : UIView {
    @IBOutlet var itemImageView : UIImageView?
    @IBOutlet var itemTitleLabel : UILabel?
    @IBOutlet var itemPrice : UILabel?
    @IBOutlet var itemSalePrice : UILabel?
    @IBOutlet var itemDescriptionLabel : UILabel?
    @IBOutlet var itemRatingImageView : UIImageView?
    @IBOutlet var itemNumReviewsLabel : UILabel?

    @IBOutlet var viewWidth : NSLayoutConstraint!
    @IBOutlet var itemDescriptionTopSpacing : NSLayoutConstraint!

    weak var sizeCache : CellSizeCache?

    var indexPath : IndexPath?

    var item : ResponseItem? {
        willSet {
            itemImageView?.image = nil
            itemTitleLabel?.text = nil
            itemPrice?.text = nil
            itemSalePrice?.text = nil
            itemDescriptionLabel?.text = nil
            itemRatingImageView?.image = nil
            itemNumReviewsLabel?.text = nil
        }

        didSet {
            if let item = item {
                self.itemTitleLabel?.text = item.name

                if item.msrp > 0 {
                    self.itemPrice?.text = item.msrp.priceString
                } else if item.standardShipRate > 0 {
                    self.itemPrice?.text = item.standardShipRate.priceString
                } else if item.salePrice > 0 {
                    self.itemPrice?.text = item.salePrice.priceString
                } else {
                    self.itemPrice?.text = nil
                }

                if Double(self.itemPrice?.text ?? "") ?? 0.0 > item.salePrice {
                    self.itemSalePrice?.attributedText = NSAttributedString(
                        string: item.salePrice.priceString,
                        attributes: [
                            NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue,
                            NSForegroundColorAttributeName : self.itemSalePrice?.textColor ?? UIColor.darkGray,
                            NSFontAttributeName : self.itemSalePrice?.font ?? UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                            NSBaselineOffsetAttributeName : 0
                        ]
                    )
                }

                self.itemDescriptionLabel?.text = item.shortDescription.unescapedHTML.stripHTML

                if item.numReviews > 0 {
                    self.itemNumReviewsLabel?.text = "(\(item.numReviews))"
                } else {
                    self.itemNumReviewsLabel?.text = nil
                }
                self.itemNumReviewsLabel?.isHidden = true

                if (self.itemDescriptionLabel?.text ?? "").characters.count == 0 {
                    itemDescriptionTopSpacing.constant = 0
                } else {
                    itemDescriptionTopSpacing.constant = 10
                }

                var imageURL = item.largeImage

                if imageURL == nil {
                    imageURL = item.mediumImage
                }

                if let imageURL = item.bestImage {
                    let finishLoading = { [weak self] (image:UIImage?, reviewImage:UIImage?) in
                        guard let strongSelf = self else { return }

                        if strongSelf.item == item {
                            strongSelf.itemImageView?.image = image
                            strongSelf.itemRatingImageView?.image = reviewImage

                            if reviewImage != nil {
                                strongSelf.itemNumReviewsLabel?.isHidden = false
                            }

                            strongSelf.viewWidth.constant = strongSelf.superview?.bounds.width ?? 0

                            if let indexPath = strongSelf.indexPath, let _ = strongSelf.superview {
                                if strongSelf.sizeCache?.cache[indexPath] == nil {
                                    strongSelf.sizeCache?.cacheSize(forView: strongSelf, indexPath:indexPath)
                                }
                            }
                        }
                    }

                    ImageCache.shared.loadImage(imageURL: imageURL, block: { (image:UIImage?, error:Error?) in
                        if let reviewImage = item.customerRatingImage {
                            ImageCache.shared.loadImage(imageURL: reviewImage, block: { (reviewImage:UIImage?, error:Error?) in
                                finishLoading(image, reviewImage)
                            })
                        } else {
                            finishLoading(image, nil)
                        }
                    })
                }
            }
        }
    }
}
