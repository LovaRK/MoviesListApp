//
//  UICollectionView+empty.swift
//  MoviesListApp
//
//  Created by MA1424 on 24/01/24.
//

import UIKit

extension UICollectionView {
    
    func setEmptyState(withViewModel viewModel: EmptyStateViewModel) {
        // Remove any existing background views or constraints
        self.backgroundView?.removeFromSuperview()
        
        let containerView = UIView(frame: CGRect.zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Use a system image for the imageView
        let imageView = UIImageView()
        imageView.image = viewModel.image // Replace `imageName` with the SF Symbol name
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label // Use the default tint color that adapts to Light/Dark mode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = viewModel.description
        descriptionLabel.textColor = .systemGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        self.backgroundView = containerView
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 100), // Width constraint
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        // Call layoutIfNeeded to ensure that the layout is updated immediately
        self.layoutIfNeeded()
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
