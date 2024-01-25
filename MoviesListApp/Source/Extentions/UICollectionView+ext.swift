//
//  UICollectionView+empty.swift
//  MoviesListApp
//
//  Created by MA1424 on 24/01/24.
//

import UIKit

extension UICollectionView {
    
    func setEmptyState(withViewModel viewModel: EmptyStateViewModel) {
        // Create a container view to center content vertically and horizontally
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Create an image view to display the image from the view model
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .center // Adjust the content mode as needed
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = viewModel.image
            return imageView
        }()
        
        // Create a label to display the title from the view model
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = viewModel.title
            label.textColor = .black // Set the text color
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Create a label to display the description from the view model
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = viewModel.description
            label.textColor = .darkGray // Set the text color
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Add subviews to the containerView
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        // Add the containerView to the collection view's background view
        self.backgroundView = containerView
        
        // Configure constraints to center content
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

