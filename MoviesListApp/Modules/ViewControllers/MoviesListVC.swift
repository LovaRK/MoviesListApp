//
//  MoviesListVC.swift
//  MoviesListApp
//
//  Created by MA1424 on 19/01/24.
//

import UIKit

class MoviesListVC: UIViewController {
    
    private var viewModel: MoviesListViewModel
    private var collectionViewManager: CollectionViewManager<MoviesListViewModel, MovieCollectionViewCell>?
    private var collectionView: UICollectionView! // Ensure this is correctly initialized
    
    private var searchManager: SearchManager?
    
    init(viewModel: MoviesListViewModel, title: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchInitialMovies()
    }
    
    private func fetchInitialMovies() {
        viewModel.fetchMovies(page: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.moviesUpdated()
            }
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemGray5
        setupCollectionView()
        setupCollectionViewManager()
        configureSearchManager()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupCollectionViewManager() {
        collectionViewManager = CollectionViewManager(collectionView: collectionView, viewModel: viewModel, cellType: MovieCollectionViewCell.self)
        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func moviesUpdated() {
        collectionView.reloadData()
    }
}



