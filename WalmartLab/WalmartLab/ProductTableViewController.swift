//
//  ProductTableViewController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 6/3/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ProductListCell : UITableViewCell {
    @IBOutlet weak var itemView : ProductListView?
}

class ProductTableViewController : UITableViewController {
    var items = [ResponseProduct]()
    var sizeCache = CellSizeCache()
    let paginator = TestAPIPaginator()
    @IBOutlet var pageLoadingView : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        sizeCache.delegate = self
        paginator.delegate = self
        paginator.scrollView = self.tableView

        self.tableView.tableFooterView = self.pageLoadingView
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)

        if let parent = self.parent as? SearchViewController {
            self.tableView.tableHeaderView = parent.textFieldContainer
        }
    }

    func updateDetailViewController(_ controller:UIViewController, selectedIndex:Int? = 0) {
        if let detailController = controller as? ProductDetailPageViewController {
            detailController.items = items

            if let index = selectedIndex {
                detailController.currentItem = index
            }

            configurePageSelectionBlockIfNecessary(detailController:detailController)
        }
    }

    func configurePageSelectionBlockIfNecessary(detailController:ProductDetailPageViewController) {
        if detailController.pageDidTurnBlock == nil {
            detailController.pageDidTurnBlock = { [weak self, unowned detailController] in
                guard let strongSelf = self else { return }

                strongSelf.tableView.selectRow(at: IndexPath(row:detailController.currentItem, section:0),
                                               animated: true,
                                               scrollPosition: .middle)
                strongSelf.paginator.loadNextPageIfNecessary(currentItemNumber: detailController.currentItem + 1)
            }
        }
    }

    func showCurrentItem() {
        var indexPath = IndexPath(row:0, section:0)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            indexPath = selectedIndexPath
        } else {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        self.performSegue(withIdentifier: "showDetail", sender: tableView.cellForRow(at: indexPath))
    }

    func updateItems() {
        guard let splitController = self.splitViewController else { return }
        guard let detailNavController = splitController.viewControllers.last as? UINavigationController else { return }

        // iphone vs. ipad they have different view controller structure in split view controller.
        if let detailController = detailNavController.childViewControllers.first as? ProductDetailPageViewController {
            detailController.items = items
        } else if let detailController = detailNavController.topViewController?.childViewControllers.first as? ProductDetailPageViewController {
            detailController.items = items
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow, let controller = (segue.destination as! UINavigationController).topViewController {
                let navigationItem = controller.navigationItem

                updateDetailViewController(controller, selectedIndex: indexPath.row)

                navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                navigationItem.leftItemsSupplementBackButton = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ProductListCell

        assert(cell.itemView != nil)

        let itemView = cell.itemView!

        itemView.item = items[indexPath.row]
        itemView.indexPath = indexPath
        itemView.sizeCache = sizeCache

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginator.loadNextPageIfNecessary(currentItemNumber: indexPath.row + 1)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sizeCache.cache[indexPath] ?? sizeCache.defaultHeight
    }
}

extension ProductTableViewController : APIResultResponder {
    func willStartAPIRequest() {
        self.view.isHidden = self.items.count == 0
    }

    func showSuccessState(resultPage: ResponseModel?) {
        if let resultPage = resultPage as? ResponseProductPage {
            if resultPage.pageNumber == 1 {
                paginator.reset()
                paginator.set(page: resultPage)

                items = resultPage.products

                sizeCache.cache.removeAll()
                self.tableView.reloadData()

                if !items.isEmpty && UIDevice.current.userInterfaceIdiom == .pad {
                    showCurrentItem()
                }
            } else {
                var rows = [IndexPath]()

                paginator.set(page: resultPage)

                self.tableView.beginUpdates()

                items += resultPage.products
                for i in (paginator.start-1 ..< items.count) {
                    rows.append(IndexPath(row:i, section:0))
                }
                self.tableView.insertRows(at: rows, with: .automatic)

                self.tableView.endUpdates()
                updateItems()
            }

            // there is nothing more to load. hide page loading indicator
            if paginator.isAtEnd {
                self.tableView.tableFooterView = UIView()
            }
        }
        self.view.isHidden = self.items.count == 0
    }

    func showFailureState(resultPage: ResponseModel?) {
    }
}

extension ProductTableViewController : CellSizeCacheDelegate {
    func cellSizeCache(_ cellSizeCache: CellSizeCache, didUpdateHeight height: CGFloat, indexPath:IndexPath) {
        guard cellSizeCache.cache.count > 0 else { return }

        UIView.performWithoutAnimation {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension ProductTableViewController : TestAPIPaginatorDelegate {
    func paginator(_ paginator: TestAPIPaginator, didRequestPageWithStart start: Int) {
        if let parent = self.parent as? ProductListController {
            parent.appendPage(start: start)
        }
    }
}
