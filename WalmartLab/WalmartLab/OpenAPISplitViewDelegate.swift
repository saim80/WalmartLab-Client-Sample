//
//  OpenAPISplitViewDelegate.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/4/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class OpenAPISplitViewDelegate : NSObject, UISplitViewControllerDelegate {
    override init() {
        super.init()
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? ReviewViewController else { return false }
        if topAsDetailController.item == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }

        return false
    }
}
