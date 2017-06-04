//
//  APIRetryViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import UIKit

let APIRetryViewControllerSegueIDShow = "showAPIRetry"
let APIRetryViewControllerSegueIDHide = "hideAPIRetry"

class APIRetryViewController: UIViewController {

    @IBOutlet weak var activityView:UIActivityIndicatorView!
    @IBOutlet weak var button:UIButton!
    @IBOutlet weak var errorLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func prepareRequest() {
        button.isHidden = true
        activityView.isHidden = false
    }

    func finalizeRequest() {
        button.isHidden = false
        activityView.isHidden = true
    }

    @IBAction func retry(sender:UIButton) {
        if let parent = self.parent as? APIResultViewController {
            parent.invokeAPI()
        }
    }
}

extension APIRetryViewController : APIResultResponder {
    func willStartAPIRequest() {
        prepareRequest()
    }

    func showSuccessState(resultPage: ResponseModel?) {
        finalizeRequest()

        errorLabel.text = nil

        self.performSegue(withIdentifier: APIRetryViewControllerSegueIDHide, sender: self)
    }

    func showFailureState(resultPage: ResponseModel?) {
        finalizeRequest()

        errorLabel.text = nil

        if let object = resultPage as? ResponseBase {
            if let firstError = object.errors.first {
                errorLabel.text = firstError.message
            }
        }
    }
}
