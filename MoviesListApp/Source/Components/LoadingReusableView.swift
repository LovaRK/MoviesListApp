//
//  LoadingReusableView.swift
//  MoviesListApp
//
//  Created by MA1424 on 20/01/24.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {
    static let identifier = "LoadingReusableView"

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(activityIndicator)
        self.backgroundColor = .red
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func getActivityIndicator() -> UIActivityIndicatorView {
        return activityIndicator
    }
}

