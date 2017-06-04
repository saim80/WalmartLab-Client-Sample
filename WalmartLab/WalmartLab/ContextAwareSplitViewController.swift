//
//  SplitViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/4/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

/// This class is useful if you want to configure delegate object in storyboard or xib without having to write a code for each context.
class ContextAwareSplitViewController : UISplitViewController {
    @IBOutlet var contextDelegate : Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
    }
}
