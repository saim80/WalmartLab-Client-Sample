//
//  ProductDetailPageController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailPageViewController : UIPageViewController {
    @IBOutlet var productDetailDataSource: ProductDetailPageDataSource!
    @IBOutlet var productDetailController: ProductDetailPageController!

    var items : [ResponseProduct] {
        set {
            productDetailDataSource.items = newValue
        }
        get {
            return productDetailDataSource.items
        }
    }

    var currentItem : Int {
        set {
            productDetailDataSource.currentItem = newValue
        }
        get {
            return productDetailDataSource.currentItem
        }
    }

    var pageDidTurnBlock : (()->Void)?

    class func viewController(product:ResponseProduct, atIndex index:Int) -> ProductDetailViewController {
        let controller = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)

        controller.item  = product
        controller.index = index

        return controller
    }

    func setVisibleViewController(product:ResponseProduct, atIndex index:Int) {
        let controller = type(of:self).viewController(product:product, atIndex:index)

        setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
}

class ProductDetailPageDataSource : NSObject, UIPageViewControllerDataSource {
    @IBOutlet weak var viewController : ProductDetailPageViewController?

    required init(viewController:ProductDetailPageViewController) {
        super.init()

        self.viewController = viewController
    }

    override init() {
        super.init()
    }

    func showPage(at index:Int) {
        assert((0 ..< items.count).contains(index), "Invalid currentItem set.")
        viewController?.setVisibleViewController(product: items[index], atIndex: index)
    }

    var items = [ResponseProduct]() {
        didSet {
            if items != oldValue {
                if oldValue.isEmpty {
                    showPage(at: 0)
                }
            }
        }
    }
    var currentItem : Int {
        set {
            if currentItem != newValue {
                showPage(at: newValue)
            }
        }
        get {
            let controller = viewController?.viewControllers?.first as? ProductDetailViewController

            return controller?.index ?? 0
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var outController : UIViewController?
        let previousController = viewController as? ProductDetailViewController
        let newItem = (previousController?.index ?? 0) + 1

        if (0 ..< items.count).contains(newItem) {
            outController = ProductDetailPageViewController.viewController(product: items[newItem], atIndex: newItem)
        }

        return outController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var outController : UIViewController?
        let nextController = viewController as? ProductDetailViewController
        let newItem = (nextController?.index ?? 0) - 1

        if (0 ..< items.count).contains(newItem) {
            outController = ProductDetailPageViewController.viewController(product: items[newItem], atIndex: newItem)
        }

        return outController
    }
}

class ProductDetailPageController : NSObject, UIPageViewControllerDelegate {
    @IBOutlet weak var viewController : ProductDetailPageViewController?

    override init() {
        super.init()
    }

    required init(viewController:ProductDetailPageViewController) {
        super.init()

        self.viewController = viewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        viewController?.pageDidTurnBlock?()
    }
}
