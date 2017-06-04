//
//  ReviewViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

let ReviewViewControllerSegueIDSetTableView = "setTableView"

class ReviewViewController : APIResultViewController {
    var item : ResponseItem?

    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var tableViewContainer : UIView!

    override func endPoint<ResponseType, ModelType>() -> APIEndpoint<ResponseType, ModelType>? where ModelType : ResponseModel {
        let result = APIServiceCenter.shared.walmartLab.endPoints[WalmartLabService.EndPoints.reviews] as? APIEndpoint<ResponseType, ModelType>


        result?.setValue(self.item?.itemId ?? 0, forKey: "itemId")

        assert(result != nil, "end point must not be nil. Check end point registraion before executing this code.")

        return result
    }

    override func invokeAPI(completion: ((Bool) -> Void)? = nil) {
        super.invokeAPI(completion: completion)

        let invokedEndpoint = self.invokeAPIEndpoint() as APIEndpoint<[String:Any], ResponseReviewPage>?

        messageLabel.text = NSLocalizedString("Loading Reviews...", comment: #file)

        assert(invokedEndpoint != nil, "No endpoint was properly invoked.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        invokeAPI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: ReviewViewControllerSegueIDSetTableView, sender: self)
    }

    override func showAPISuccess<ResponseType, ModelType>(invocation: APIInvocation<ResponseType, ModelType>) where ModelType : ResponseModel {
        super.showAPISuccess(invocation: invocation)

        if let pageResult = invocation.dataModel as? ResponseReviewPage {
            if pageResult.reviews.count == 0 {
                messageLabel.text = NSLocalizedString("There are no reviews for this item.", comment: #file)
            }
        }
    }
}

class ReviewContentSegue : UIStoryboardSegue {
    override func perform() {
        if self.identifier == ReviewViewControllerSegueIDSetTableView {
            assert((self.source as? ReviewViewController)?.tableViewContainer != nil)

            if let controller = self.source as? ReviewViewController, let container = controller.tableViewContainer {
                controller.addChildViewController(self.destination)
                self.destination.view.frame = container.bounds
                container.addSubview(self.destination.view)
                self.destination.didMove(toParentViewController: controller)
            }
        }
    }
}
