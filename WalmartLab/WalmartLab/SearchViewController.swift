//
//  SearchViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/27/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

let SearchViewControllerSegueIDSetTextFieldController = "setTextFieldController"
let SearchViewControllerSegueIDSetResultController = "setResultController"

class SearchViewController : APIResultViewController {
    @IBOutlet var textFieldContainer : UIView?
    @IBOutlet var resultContainer : UIView?

    override func endPoint<ResponseType, ModelType>() -> APIEndpoint<ResponseType, ModelType>? where ModelType : ResponseModel {
        let result = APIServiceCenter.shared.walmartLab.endPoints[WalmartLabService.EndPoints.searchResult] as? APIEndpoint<ResponseType, ModelType>

        assert(result != nil, "end point must not be nil. Check end point registraion before executing this code.")

        return result
    }

    var query = ""

    func setSearchParameters(_ params:[(SearchResultEndPoint.ParameterKey, CustomStringConvertible)]) {
        setAPIParameters(params)
    }

    func refresh(query:String) {
        self.query = query
        setSearchParameters([(.query, query)])
        invokeAPI()
    }

    func appendPage(start:Int) {
        if query.characters.count > 0 {
            setSearchParameters([(.query, query), (.start, start)])
            invokeAPI()
        } else {
            debugPrint("No query string is set. We aren't going to append more pages.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: SearchViewControllerSegueIDSetTextFieldController, sender: self)
        self.performSegue(withIdentifier: SearchViewControllerSegueIDSetResultController, sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showRandomSearchResultsIfNoQueryIsSet()
    }

    override func invokeAPI(completion: ((Bool) -> Void)? = nil) {
        super.invokeAPI(completion: completion)

        let invokedEndpoint = self.invokeAPIEndpoint() as APIEndpoint<[String:Any], ResponseSearchResultPage>?

        assert(invokedEndpoint != nil, "No endpoint was properly invoked.")
    }

    func showRandomSearchResultsIfNoQueryIsSet() {
        let randomKeywords = ["iphone", "lucky", "ipad", "shampoo", "water", "coffee"]

        if query.characters.count == 0 {
            let i = Int(arc4random()) % randomKeywords.count
            self.refresh(query: randomKeywords[i])
        }
    }
}

class SearchContentSegue : UIStoryboardSegue {
    override func perform() {
        if self.identifier == SearchViewControllerSegueIDSetResultController {
            assert((self.source as? SearchViewController)?.resultContainer != nil)

            if let controller = self.source as? SearchViewController, let container = controller.resultContainer {
                controller.addChildViewController(self.destination)
                self.destination.view.frame = container.bounds
                container.addSubview(self.destination.view)
                self.destination.didMove(toParentViewController: controller)
            }
        } else if self.identifier == SearchViewControllerSegueIDSetTextFieldController {
            assert((self.source as? SearchViewController)?.textFieldContainer != nil)

            if let controller = self.source as? SearchViewController, let container = controller.textFieldContainer {
                controller.addChildViewController(self.destination)
                self.destination.view.frame = container.bounds
                container.addSubview(self.destination.view)
                self.destination.didMove(toParentViewController: controller)
            }
        }
    }
}

