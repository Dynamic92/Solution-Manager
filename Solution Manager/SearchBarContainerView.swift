//
//  SearchBarContainerView.swift
//  Solution Manager
//
//  Created by Dario Arrigo on 19/11/2019.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import UIKit

class SearchBarContainerView: UIView {
  
    let searchBar: UISearchBar
  
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        searchBar.barTintColor = UIColor.white
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = true
        searchBar.alpha = 1
        searchBar.placeholder = "Search RFC"
        addSubview(searchBar)
    }
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
