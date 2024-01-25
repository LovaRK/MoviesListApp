//
//  MovieHomeViewController.swift
//  MoviesListApp
//
//  Created by MA1424 on 13/01/24.
//

import UIKit

class MovieHomeVC: UIViewController {
    
    private var viewModel: MovieHomeViewModel
    private var collectionViewManager: CollectionViewManager<MovieHomeViewModel, MovieCollectionViewCell>?
    private let activityIndicatorManager = ActivityIndicatorManager<UIView>()
    private var collectionView: UICollectionView!
    
    private lazy var codeSegmented: CustomSegmentedControl = {
        let frame = calculateSegmentedControlFrame()
        let codeSegmented = CustomSegmentedControl(frame: frame, buttonTitle: [])
        codeSegmented.backgroundColor = .systemBackground
        codeSegmented.delegate = self
        codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        return codeSegmented
    }()
    
    private var searchManager: SearchManager?
    
    init(viewModel: MovieHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGenres()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
        navigationItem.title = "Home"
        setupActivityIndicator()
        setupCollectionView()
        setupCollectionViewManager()
        configureSegmentedControl()
        configureSearchManager()
    }
    
    private func setupActivityIndicator() {
        viewModel.isLoadingIndicatorVisible = { [weak self] isVisible in
            DispatchQueue.main.async {
                if isVisible {
                    self?.activityIndicatorManager.showActivityIndicator(on: self?.view ?? UIView())
                } else {
                    self?.activityIndicatorManager.hideActivityIndicator()
                }
            }
        }
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
    
    private func setupCollectionViewManager() {
        collectionViewManager = CollectionViewManager(collectionView: collectionView, viewModel: viewModel, cellType: MovieCollectionViewCell.self)
        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
    }
    
    private func configureSegmentedControl() {
        view.addSubview(codeSegmented)
        NSLayoutConstraint.activate([
            codeSegmented.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -5),
            codeSegmented.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            codeSegmented.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            codeSegmented.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func fetchGenres() {
        viewModel.fetchGenres { [weak self] genres, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching genres: \(error.localizedDescription)")
                    return
                }
            if let genres = genres?.genres, !genres.isEmpty {
                    self.genresFetched()
                    self.viewModel.resetDataForNewGenre() // Reset movies and pagination for the first genre
                    self.viewModel.loadMoreData {
                        self.moviesUpdated()
                    }
                } else {
                    print("Error or no genres available.")
                }
            }
        }
    
    private func genresFetched() {
        let genres = viewModel.getGenres().compactMap { $0.name }
        codeSegmented.setButtonTitles(buttonTitles: genres)
        codeSegmented.setIndex(index: 0)
    }
    
    private func moviesUpdated() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func configureSearchManager() {
        searchManager = SearchManager()
        searchManager?.setupSearchController(for: self)
        searchManager?.onSearchResults = { [weak self] inputString in
            self?.viewModel.filterMovies(with: inputString) {
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    private func calculateSegmentedControlFrame() -> CGRect {
        // Placeholder - implement based on your UI requirements
        let frame: CGRect
        if UIDevice.current.interfaceType == .dynamicIsland {
            frame = CGRect(x: 0, y: 97, width: self.view.frame.width, height: 40)
        } else if UIDevice.current.interfaceType == .notch {
            frame = CGRect(x: 0, y: 90, width: self.view.frame.width, height: 40)
        } else {
            frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 40)
        }
        return frame
    }
}

// CustomSegmentedControlDelegate
extension MovieHomeVC: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        viewModel.changeGenre(to: index) {
            self.moviesUpdated()
            self.scrollToTop()
            self.moviesUpdated()
        }
    }
    
    private func scrollToTop() {
        if collectionView.numberOfSections > 0, collectionView.numberOfItems(inSection: 0) > 0 {
            let topIndexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
        }
    }
}







