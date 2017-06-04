//
//  ProductDetailView.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/4/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailView : ProductView {
    @IBOutlet var shortDescriptionLabel : UILabel!

    override func finalizeItemSet() {
        super.finalizeItemSet()
        if let item = item {
            self.shortDescriptionLabel.text = item.shortDescription.unescapedHTML.stripHTML
        }
    }
}
