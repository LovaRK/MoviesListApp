//
//  MovieEmptyStateView.swift
//  MoviesListApp
//
//  Created by MA1424 on 24/01/24.
//

import UIKit

protocol EmptyStateViewModel {
    var title: String { get }
    var description: String { get }
    var image: UIImage? { get }
}


class MovieEmptyStateViewModel: EmptyStateViewModel {
    var title: String {
        return "No Movies Found"
    }

    var description: String {
        return "There are no movies available in this category."
    }

    var image: UIImage? {
        return UIImage(systemName: "person.crop.rectangle.stack.fill")
    }
}
