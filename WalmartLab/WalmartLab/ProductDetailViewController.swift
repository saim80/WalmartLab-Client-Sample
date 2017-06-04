//
//  ProductDetailViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailViewController : UIViewController {
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var detailView : ProductDetailView!
    var index = 0
    var item : ResponseProduct? {
        didSet {
            if item != oldValue {
                configureDetailView()
            }
        }
    }

    func configureDetailView() {
        guard let _ = detailView else { return }

        detailView.item = item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailView()
    }
}
