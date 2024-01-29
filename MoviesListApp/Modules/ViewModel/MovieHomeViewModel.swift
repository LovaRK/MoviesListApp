//
//  HomeViewModel.swift
//  MoviesListApp
//
//  Created by MA1424 on 14/01/24.
//

import Foundation

class MovieHomeViewModel {
    
    private var genres: [Genre] = []
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private let apiService: APIService
    internal var currentPage = 1
    private var isFetching = false
    private var selectedGenreId: Int?
    internal var totalPages = 1
    
    var isLoadingIndicatorVisible: ((Bool) -> Void)?
    
    var isSearchActive: Bool = false
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchGenres(completion: @escaping (Genres?, APIError?) -> Void) {
        isLoadingIndicatorVisible?(true)
        apiService.fetchGenres { [weak self] result in
            guard let self = self else { return }
            self.isLoadingIndicatorVisible?(false)
            switch result {
            case .success(let fetchedGenres):
                self.handleFetchedGenres(fetchedGenres)
                completion(fetchedGenres, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func handleFetchedGenres(_ fetchedGenres: Genres) {
        if let genres = fetchedGenres.genres {
            self.genres = genres
            self.selectedGenreId = genres.first?.id
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
    
    func getGenres() -> [Genre] {
        return genres
    }
    
    func getFilteredMovies() -> [Movie] {
        return filteredMovies
    }
    
    func changeGenre(to index: Int, completion: @escaping () -> Void) {
        guard let genreId = genres[safe: index]?.id, selectedGenreId != genreId else { return }
        selectedGenreId = genreId
        resetDataForNewGenre()
        loadMoreData(completion: completion)
    }
    
    private func handleFetchMoviesResult(_ result: Result<(movies: [Movie], totalPages: Int), APIError>, completion: @escaping () -> Void) {
        defer { self.isFetching = false }
        switch result {
        case .success(let fetchedMovies):
            if !fetchedMovies.movies.isEmpty {
                self.movies.append(contentsOf: fetchedMovies.movies)
                self.filteredMovies = self.movies
                self.currentPage += 1
                self.totalPages = fetchedMovies.totalPages
            } else {
                print("No more movies fetched.")
            }
        case .failure(let error):
            print("Error fetching more movies: \(error)")
        }
        DispatchQueue.main.async {
            completion()
        }
    }

}

// Extension to handle safe array access
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// Conforming to CollectionViewCompatible
extension MovieHomeViewModel: CollectionViewCompatible {
    
    var numberOfSections: Int { 1 }
    
    var isFetchingData: Bool { isFetching }
    
    func numberOfItems(inSection section: Int) -> Int { getFilteredMovies().count }
    
    func staticCellIdentifier() -> String { "MovieCell" }
    
    func cellIdentifier(forIndexPath indexPath: IndexPath) -> String { "MovieCell" }
    
    func cellData(forIndexPath indexPath: IndexPath) -> Movie? {
        return getFilteredMovies()[safe: indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) { /* Handle item selection logic here */ }
}


extension MovieHomeViewModel: PaginationHandling {
    
    func loadMoreData(completion: @escaping () -> Void) {
        guard !isFetching, let genreId = selectedGenreId, currentPage <= totalPages, !isSearchActive else {
            completion()
            return
        }
        isFetching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.apiService.fetchMovies(forGenre: genreId, page: self.currentPage) { [weak self] result in
                self?.handleFetchMoviesResult(result, completion: completion)
            }
        }
    }

    
    func getTotalPages() -> Int { totalPages }
    
    func getCurrentPage() -> Int { currentPage }
    
    func getIsSearchActive() -> Bool {
        return isSearchActive
    }
}


