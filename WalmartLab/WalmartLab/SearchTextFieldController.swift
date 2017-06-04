//
//  SearchTextFieldController.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/29/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class SearchTextFieldController : UIViewController {
    @IBOutlet weak var textField : UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField?.placeholder = NSLocalizedString("Enter search text.", comment: #file)
        self.textField?.delegate = self
    }

    fileprivate func enableUserInput() {
        if let textField = self.textField {
            textField.isUserInteractionEnabled = true
            textField.alpha = 1
        }
    }

    fileprivate func disableUserInput() {
        if let textField = self.textField {
            textField.isUserInteractionEnabled = false
            textField.alpha = 0.5
        }
    }
}

extension SearchTextFieldController : UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let parent = self.parent as? SearchViewController {
            let components = searchBar.text?.components(separatedBy: " ")
            let invalidCharacters = CharacterSet.alphanumerics.inverted

            if let safeText = components?.reduce("", { (result:String, item:String) -> String in
                let safeText = item.trimmingCharacters(in: invalidCharacters)

                if safeText.characters.count > 0 {
                    if result.characters.count == 0 {
                        return item
                    } else {
                        return "\(result) \(item)"
                    }
                }

                return result
            }) {
                if safeText.characters.count > 0 {
                    searchBar.text = safeText
                    searchBar.placeholder = NSLocalizedString("Enter search text.", comment: #file)
                    parent.refresh(query: safeText)
                }
            } else {
                searchBar.text = nil
                searchBar.placeholder = NSLocalizedString("Invalid search text.", comment: #file)
            }
        }
        searchBar.showsCancelButton = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        textField?.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        textField?.endEditing(true)
    }
}

extension SearchTextFieldController : APIResultResponder {
    func willStartAPIRequest() {
        disableUserInput()
    }

    func showFailureState(resultPage: ResponseModel?) {
        enableUserInput()
    }

    func showSuccessState(resultPage: ResponseModel?) {
        enableUserInput()
    }
}
