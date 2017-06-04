//
//  ReviewTableViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ReviewTableViewController : UITableViewController {
    var items = [ResponseReview]()
    var sizeCache = CellSizeCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ReviewItemCell

        cell.itemView?.indexPath = indexPath
        cell.itemView?.sizeCache = sizeCache
        cell.itemView?.item = items[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeCache.cache[indexPath] ?? sizeCache.defaultHeight
    }
}

extension ReviewTableViewController : APIResultResponder {
    func willStartAPIRequest() {
        self.view.isHidden = self.items.count == 0
    }

    func showSuccessState(resultPage: ResponseModel?) {

        if let resultPage = resultPage as? ResponseReviewPage {
            self.items = resultPage.reviews
            sizeCache.cache.removeAll()
            self.tableView.reloadData()
        }

        self.view.isHidden = self.items.count == 0
    }

    func showFailureState(resultPage: ResponseModel?) {
    }
}

extension ReviewTableViewController : CellSizeCacheDelegate {
    func cellSizeCache(_ cellSizeCache: CellSizeCache, didUpdateHeight height: CGFloat, indexPath:IndexPath) {
        guard cellSizeCache.cache.count > 0 else { return }

        UIView.performWithoutAnimation {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
