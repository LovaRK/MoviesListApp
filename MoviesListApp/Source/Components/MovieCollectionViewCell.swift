//
//  MovieCollectionViewCell.swift
//  MoviesListApp
//
//  Created by MA1424 on 15/01/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let yearLabel = UILabel()
    
    private var imageLoadTaskID: UUID?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // ImageView setup
        imageView.contentMode = .scaleToFill // Changed from .scaleToFill to preserve image aspect ratio
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // NameLabel setup
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .white // Ensures visibility in both light and dark modes
        nameLabel.numberOfLines = 2 // Allows the title to wrap to two lines
        nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75) // Semi-transparent background
        nameLabel.layer.cornerRadius = 4
        nameLabel.layer.masksToBounds = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        // YearLabel setup
        yearLabel.font = UIFont.systemFont(ofSize: 14)
        yearLabel.textColor = .white // Slightly less prominence than the title
        yearLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75) // Semi-transparent background
        yearLabel.layer.cornerRadius = 4
        yearLabel.layer.masksToBounds = true
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(yearLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: yearLabel.topAnchor, constant: -5),
            
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTaskID.map(ImageLoader.cancelLoad)
        imageView.image = nil // Reset image
    }
}


extension MovieCollectionViewCell: ConfigurableCell {
    typealias DataType = Movie
    
    func cancelImageLoadTask() {
        imageLoadTaskID.map(ImageLoader.cancelLoad)
    }
    
    func configure(with movie: Movie) {
        nameLabel.text = movie.title
        yearLabel.text = "N/A" // Default value
        if let releaseDate = movie.releaseDate, let date = Utils.dateFromString(releaseDate) {
            yearLabel.text = Utils.yearStringFromDate(date)
        }
        
        imageLoadTaskID = ImageLoader.loadImage(from: movie.posterPath ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                case .failure:
                    self.imageView.image = UIImage(systemName: "photo.artframe")
                    self.imageView.tintColor = . black
                }
            }
        }
    }
}
