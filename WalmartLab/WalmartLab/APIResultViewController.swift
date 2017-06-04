//
//  APIResultViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

protocol APIResultResponder : NSObjectProtocol {
    func willStartAPIRequest()
    func showSuccessState(resultPage:ResponseModel?)
    func showFailureState(resultPage:ResponseModel?)
}

class APIResultViewController : UIViewController {
    func endPoint<ResponseType, ModelType:ResponseModel>() -> APIEndpoint<ResponseType, ModelType>? {
        return nil
    }

    @IBOutlet weak var retryContainer : UIView?

    var queryFragments = Set<APIInvocationQueryFragment>()
    var completionBlock : ((Bool)->Void)?

    func setAPIParameters<KeyType:CustomStringConvertible>(_ params:[(KeyType, CustomStringConvertible)]) {
        self.queryFragments.removeAll()
        for paramPair in params {
            self.queryFragments.insert(APIInvocationQueryFragment(key: paramPair.0, value: paramPair.1))
        }
    }

    private func enumerateChildControllers(block:(APIResultResponder)->Void) {
        for child in childViewControllers {
            if let controller = child as? APIResultResponder {
                block(controller)
            }
        }
    }

    private var childControllerViews : Set<UIView> {
        var controllerViews = Set<UIView>()

        for controller in childViewControllers {
            controllerViews.insert(controller.view)
        }

        return controllerViews
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.retryContainer?.isHidden = true
    }

    private func enumerateSubviews(forView view:UIView, excludingViews exclusion:Set<UIView>, block:(APIResultResponder)->Void) {
        for subview in view.subviews {
            // view controllers receive this message. skip
            if exclusion.contains(subview) { continue }
            // table view should have its controller to receive this message. skip
            if subview is UITableView { continue }
            // collection view should have its controller to receive this message. skip
            if subview is UICollectionView { continue }

            // otherwise, we traverse the view hierarchy and tell all APIResultResponder about api request state changes.
            if let responder = subview as? APIResultResponder {
                block(responder)
            } else {
                enumerateSubviews(forView: subview, excludingViews: exclusion, block: block)
            }
        }
    }

    func showAPIFailure<ResponseType, ModelType:ResponseModel>(invocation:APIInvocation<ResponseType, ModelType>) {
        self.enumerateChildControllers { (controller:APIResultResponder) in
            controller.showFailureState(resultPage: invocation.dataModel)
        }

        self.enumerateSubviews(forView: self.view, excludingViews: childControllerViews) { (view:APIResultResponder) in
            view.showFailureState(resultPage: invocation.dataModel)
        }
    }

    func showAPISuccess<ResponseType, ModelType:ResponseModel>(invocation:APIInvocation<ResponseType, ModelType>) {
        self.enumerateChildControllers { (controller:APIResultResponder) in
            controller.showSuccessState(resultPage: invocation.dataModel)
        }
        self.enumerateSubviews(forView: self.view, excludingViews: childControllerViews) { (view:APIResultResponder) in
            view.showSuccessState(resultPage: invocation.dataModel)
        }
    }

    func invokeAPI(completion:((Bool)->Void)? = nil) {
        self.enumerateChildControllers { (controller:APIResultResponder) in
            controller.willStartAPIRequest()
        }
        self.enumerateSubviews(forView: self.view, excludingViews: childControllerViews) { (view:APIResultResponder) in
            view.willStartAPIRequest()
        }

        if let completion = completion {
            completionBlock = completion
        }

        // subclass must generic 'invokeAPI' method with correct types.
    }

    func invokeAPIEndpoint<ResponseType, ModelType:ResponseModel>() -> APIEndpoint<ResponseType, ModelType>? {
        if let endPoint = endPoint() as APIEndpoint<ResponseType, ModelType>? {
            endPoint.call(parameters: queryFragments, success:
                { [weak self] (invocation:APIInvocation<ResponseType, ModelType>?) in
                    if let invocation = invocation {
                        self?.showAPISuccess(invocation: invocation)
                    }
                    self?.completionBlock?(true)
                }, failure: { [weak self] (invocation:APIInvocation<ResponseType, ModelType>?) in
                    self?.performSegue(withIdentifier: APIRetryViewControllerSegueIDShow, sender: self)
                    if let invocation = invocation {
                        self?.showAPIFailure(invocation: invocation)
                    }
                    self?.completionBlock?(false)
                }
            )
            return endPoint
        }

        return nil
    }

    @IBAction func unwindRetryController(segue:UIStoryboardSegue) {
        if let superContainer = segue.source.view.superview?.superview {
            superContainer.sendSubview(toBack: segue.source.view.superview!)
        }
        segue.source.view.superview?.isHidden = true
        segue.source.willMove(toParentViewController: nil)
        segue.source.view.removeFromSuperview()
        segue.source.removeFromParentViewController()
    }
}

class APIResultRetrySegue : UIStoryboardSegue {
    override func perform() {
        if let container = self.source.value(forKey: "retryContainer") as? UIView {
            self.source.addChildViewController(self.destination)
            self.destination.view.frame = container.bounds
            container.addSubview(self.destination.view)
            container.isHidden = false
            self.source.view.bringSubview(toFront: container)
            self.destination.didMove(toParentViewController: self.source)
        }
    }
}
