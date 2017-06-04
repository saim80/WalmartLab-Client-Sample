//
//  ProductListViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

let ProductListControllerSegueIDSetListController = "setProductListController"

class ProductListController : APIResultViewController {
    @IBOutlet var container : UIView?

    override func endPoint<ResponseType, ModelType>() -> APIEndpoint<ResponseType, ModelType>? where ModelType : ResponseModel {
        let result = APIServiceCenter.shared.walmartLabTest.endPoints[WalmartLabTestService.EndPoints.walmartProducts] as? APIEndpoint<ResponseType, ModelType>

        assert(result != nil, "end point must not be nil. Check end point registraion before executing this code.")

        return result
    }

    func appendPage(start :Int) {
        if let endPoint = endPoint() as? ProductsEndpoint {
            endPoint.pageNumber = start / endPoint.pageSize + 1
            invokeAPI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: ProductListControllerSegueIDSetListController, sender: self)

        invokeAPI()
    }

    override func invokeAPI(completion: ((Bool) -> Void)? = nil) {
        super.invokeAPI(completion: completion)

        let invokedEndpoint = self.invokeAPIEndpoint() as APIEndpoint<[String:Any], ResponseProductPage>?

        assert(invokedEndpoint != nil, "No endpoint was properly invoked.")
    }
}

class ProductListContentSegue : UIStoryboardSegue {
    override func perform() {
        if self.identifier == ProductListControllerSegueIDSetListController {
            assert((self.source as? ProductListController)?.container != nil)

            if let controller = self.source as? ProductListController, let container = controller.container {
                controller.addChildViewController(self.destination)
                self.destination.view.frame = container.bounds
                container.addSubview(self.destination.view)
                self.destination.didMove(toParentViewController: controller)
            }
        }
    }
}

