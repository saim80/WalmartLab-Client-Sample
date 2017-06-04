//
//  SearchResultController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class SearchResultController : UITableViewController {
    var items = [ResponseItem]()
    var sizeCache = CellSizeCache()
    let paginator = OpenAPIPaginator()

    override func viewDidLoad() {
        super.viewDidLoad()

        sizeCache.delegate = self
        paginator.delegate = self
        paginator.scrollView = self.tableView

        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)

        if let parent = self.parent as? SearchViewController {
            self.tableView.tableHeaderView = parent.textFieldContainer
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow, let controller = (segue.destination as! UINavigationController).topViewController {

                if let reviewController = controller as? ReviewViewController {
                    reviewController.item = items[indexPath.row]
                }
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SearchResultItemCell

        cell.itemView?.item = items[indexPath.row]
        cell.itemView?.indexPath = indexPath
        cell.itemView?.sizeCache = sizeCache
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginator.loadNextPageIfNecessary()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeCache.cache[indexPath] ?? sizeCache.defaultHeight
    }
}

extension SearchResultController : APIResultResponder {
    func willStartAPIRequest() {
        self.view.isHidden = self.items.count == 0
    }

    func showSuccessState(resultPage: ResponseModel?) {

        if let resultPage = resultPage as? ResponseSearchResultPage {
            if resultPage.start == 1 {
                paginator.reset()
                paginator.set(page: resultPage)

                items = resultPage.items
                sizeCache.cache.removeAll()

                self.tableView.reloadData()
            } else {
                var rows = [IndexPath]()

                paginator.set(page: resultPage)

                self.tableView.beginUpdates()
                items += resultPage.items
                for i in (resultPage.start-1 ..< items.count) {
                    rows.append(IndexPath(row:i, section:0))
                }
                self.tableView.insertRows(at: rows, with: .automatic)
                self.tableView.endUpdates()
            }
        }
        self.view.isHidden = self.items.count == 0
    }

    func showFailureState(resultPage: ResponseModel?) {
    }
}

extension SearchResultController : CellSizeCacheDelegate {
    func cellSizeCache(_ cellSizeCache: CellSizeCache, didUpdateHeight height: CGFloat, indexPath:IndexPath) {
        guard cellSizeCache.cache.count > 0 else { return }

        UIView.performWithoutAnimation {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension SearchResultController : OpenAPIPaginatorDelegate {
    func paginator(_ paginator: OpenAPIPaginator, didRequestPageWithStart start: Int) {
        if let parent = self.parent as? SearchViewController {
            parent.appendPage(start: start)
        }
    }
}
