//
//  MovieListViewModel.swift
//  MoviesListApp
//
//  Created by MA1424 on 19/01/24.
//

import Foundation

enum MovieCategory {
    case popular
    case topRated
    case upcoming
}

class MoviesListViewModel {
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var moviesAPIService: MoviesAPIService
    private var category: MovieCategory
    private var isFetching = false
    private var currentPage = 1
    private var totalPages = 1
    var isLoadingIndicatorVisible: ((Bool) -> Void)?
    var isSearchActive: Bool = false
    
    // Initialize with a specific category
    init(apiService: MoviesAPIService, category: MovieCategory) {
        self.moviesAPIService = apiService
        self.category = category
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        isLoadingIndicatorVisible?(true)
        
        fetchMoviesByCategory(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingIndicatorVisible?(false)
            switch result {
            case .success(let moviesResponse):
                self.currentPage += 1
                self.totalPages = moviesResponse.totalPages ?? self.currentPage
                self.movies.append(contentsOf: moviesResponse.movies ?? [])
                self.filteredMovies = self.movies
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
            completion(result)
        }
    }
    
    private func fetchMoviesByCategory(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        switch category {
        case .popular:
            moviesAPIService.fetchPopularMovies(page: page, completion: completion)
        case .topRated:
            moviesAPIService.fetchTopratedMovies(page: page, completion: completion)
        case .upcoming:
            moviesAPIService.fetchUpcomingMovies(page: page, completion: completion)
        }
    }
    
    func filterMovies(with searchText: String, completion: @escaping () -> Void) {
        isSearchActive = !searchText.isEmpty
        filteredMovies = searchText.isEmpty ? movies : movies.filter {
            $0.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        completion()
    }
    
    func resetDataForNewGenre() {
        movies.removeAll()
        filteredMovies.removeAll()
        currentPage = 1
    }
    
    func getFilteredMovies() -> [Movie] {
        return filteredMovies
    }
}

// Conforming to CollectionViewCompatible
extension MoviesListViewModel: CollectionViewCompatible {
    
    var numberOfSections: Int { 1 }
    var isFetchingData: Bool { isFetching }
    func numberOfItems(inSection section: Int) -> Int { getFilteredMovies().count }
    func staticCellIdentifier() -> String { "MovieCell" }
    func cellIdentifier(forIndexPath indexPath: IndexPath) -> String { "MovieCell" }
    func cellData(forIndexPath indexPath: IndexPath) -> Movie? { getFilteredMovies()[indexPath.row] }
    func didSelectItemAt(indexPath: IndexPath) { /* Implement as needed */ }
}

// Conforming to PaginationHandling
extension MoviesListViewModel: PaginationHandling {
    
    func getIsSearchActive() -> Bool { isSearchActive }
    
    func loadMoreData(completion: @escaping () -> Void) {
        guard !isFetching, currentPage <= totalPages else {
            completion()
            return
        }
        isFetching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchMovies(page: self.currentPage) { [weak self] _ in
                self?.isFetching = false
                completion()
            }
        }
    }
    
    func getTotalPages() -> Int { totalPages }
    func getCurrentPage() -> Int { currentPage }
}



