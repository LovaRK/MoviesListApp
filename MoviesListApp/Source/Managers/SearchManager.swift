//
//  SearchManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 18/01/24.
//

import UIKit

class SearchManager: NSObject, UISearchBarDelegate, UISearchResultsUpdating {
    var onSearchResults: ((String) -> Void)?
    
    func setupSearchController(for viewController: UIViewController) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items"
        searchController.searchBar.delegate = self
        viewController.navigationItem.searchController = searchController
        viewController.definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchResults?(searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            onSearchResults?(searchText)
        }
    }
}



