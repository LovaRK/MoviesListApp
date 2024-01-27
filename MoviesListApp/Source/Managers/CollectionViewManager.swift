//
//  CollectionViewManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 19/01/24.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(with data: DataType)
    func cancelImageLoadTask() // Add this method
}

protocol CollectionViewCompatible {
    associatedtype DataType
    var numberOfSections: Int { get }
    var isFetchingData: Bool { get }
    func numberOfItems(inSection section: Int) -> Int
    func staticCellIdentifier() -> String
    func cellIdentifier(forIndexPath indexPath: IndexPath) -> String
    func cellData(forIndexPath indexPath: IndexPath) -> DataType?
    func didSelectItemAt(indexPath: IndexPath)
}


protocol PaginationHandling {
    func getTotalPages() -> Int
    func getCurrentPage() -> Int
    func getIsSearchActive() -> Bool
    func loadMoreData(completion: @escaping () -> Void)
}


class CollectionViewManager<ViewModel: CollectionViewCompatible & PaginationHandling, Cell: UICollectionViewCell & ConfigurableCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where Cell.DataType == ViewModel.DataType {
    
    private var viewModel: ViewModel
    private weak var collectionView: UICollectionView?
    private var loadingView: LoadingReusableView?
    private var emptyStateViewModel: EmptyStateViewModel?
    
    init(collectionView: UICollectionView, viewModel: ViewModel, cellType: Cell.Type) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        setupCollectionView(cellType: cellType)
    }
    
    private func setupCollectionView(cellType: Cell.Type) {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(cellType, forCellWithReuseIdentifier: viewModel.staticCellIdentifier())
        collectionView?.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.identifier)
    }
    
    func updateCollectionViewData(with movies: [Movie]) {
        if movies.isEmpty {
            let emptyViewModel = MovieEmptyStateViewModel()
            collectionView?.setEmptyState(withViewModel: emptyViewModel)
        } else {
            collectionView?.restore()
        }
        collectionView?.reloadData()
    }
    
    // DataSource and Delegate methods implementation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = viewModel.cellIdentifier(forIndexPath: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        // Cancel any ongoing image loading task for the reused cell
        cell.cancelImageLoadTask()
        guard let cellData = viewModel.cellData(forIndexPath: indexPath) else { return Cell() }
        cell.configure(with: cellData)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.numberOfItems(inSection: 0) - 1, viewModel.getCurrentPage() < viewModel.getTotalPages(), !viewModel.getIsSearchActive() {
            self.viewModel.loadMoreData {
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    // size of Loading View
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if !viewModel.isFetchingData && viewModel.numberOfItems(inSection: section) > 0 {
            return CGSize(width: collectionView.bounds.size.width, height: 55) // Non-zero size
        } else {
            return .zero
        }
    }
    
    // set the Loading View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.identifier, for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    // start and stop the activityIndicator
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if viewModel.isFetchingData {
                self.loadingView?.getActivityIndicator().startAnimating()
            } else {
                self.loadingView?.getActivityIndicator().stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.getActivityIndicator().stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    // Cached item sizes for optimization
    private var cachedItemSizes = [IndexPath: CGSize]()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cachedSize = cachedItemSizes[indexPath] {
            return cachedSize
        }
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        var columns: CGFloat = 2 // Default number of columns for portrait
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            // Set number of columns for landscape
            columns = 4
        }
        // Match spacing below
        let spacing: CGFloat = 5
        let totalHorizontalSpacing = (columns - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemHeight = itemWidth * 1.2 // Assuming a height proportional to the width
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // Invalidate cached sizes if layout changes significantly
    func invalidateLayout() {
        cachedItemSizes.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Horizontal space between items
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Vertical space between items
        return 5
    }
}







