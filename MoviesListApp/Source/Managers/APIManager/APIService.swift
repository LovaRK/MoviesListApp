//
//  APIService.swift
//  MoviesListApp
//
//  Created by MA1424 on 16/01/24.
//

import Foundation

// Define the API service protocol
protocol APIService {
    func fetchGenres(completion: @escaping (Result<Genres, APIError>) -> Void)
    func fetchMovies(forGenre genreId: Int, page: Int, completion: @escaping (Result<(movies: [Movie], totalPages: Int), APIError>) -> Void)
    func fetchPopularMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    func fetchTopratedMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    
}

class MoviesAPIService: APIService {
    
    private let apiManager: APIManager
    private let localDataRepository: LocalDataRepository
    
    init(apiManager: APIManager, localDataRepository: LocalDataRepository) {
        self.apiManager = apiManager
        self.localDataRepository = localDataRepository
    }
    
    func getTotalPages() {
        
    }
    
    func fetchGenres(completion: @escaping (Result<Genres, APIError>) -> Void) {
        if ReachabilityManager.shared.isConnected {
            apiManager.request(route: APIRoute.fetchGenres) { (result: Result<Genres, APIError>) in
                switch result {
                case .success(let genres):
                    self.saveGenresToLocal(genres.genres ?? [])
                    completion(.success(genres))
                case .failure:
                    completion(.failure(.dataNotFound))
                }
            }
        } else {
            print("Internet is unavailable")
            let localGenres = self.fetchGenresFromLocal()
            completion(.success(Genres(genres: localGenres)))
        }
    }
    
    // Implement other methods similarly...
    
    func fetchMovies(forGenre genreId: Int, page: Int, completion: @escaping (Result<(movies: [Movie], totalPages: Int), APIError>) -> Void) {
        if ReachabilityManager.shared.isConnected {
            apiManager.request(route: APIRoute.fetchMovies(genreId: genreId, page: page)) { (result: Result<Movies, APIError>) in
                switch result {
                case .success(let moviesResponse):
                    self.saveMoviesToLocal(moviesResponse.movies ?? [])
                    completion(.success((movies: moviesResponse.movies ?? [], totalPages: moviesResponse.totalPages ?? 1)))
                case .failure:
                    completion(.failure(.dataNotFound))
                }
            }
        } else {
            print("Internet is unavailable")
            // This should return [MovieEntity]
            let localMoviesEntities = self.fetchMoviesFromLocal()
            completion(.success((movies: localMoviesEntities, totalPages: 1)))
        }
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        apiManager.request(route: APIRoute.fetchPopularMovies(page: page)) { (result: Result<Movies, APIError>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure:
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    func fetchTopratedMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        apiManager.request(route: APIRoute.fetchTopRatedMovies(page: page)) { (result: Result<Movies, APIError>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure:
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        apiManager.request(route: APIRoute.fetchUpcomingMovies(page: page)) { (result: Result<Movies, APIError>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure:
                completion(.failure(.dataNotFound))
            }
        }
    }
    
}


extension MoviesAPIService {
    // MARK: - Core Data Integration

    // Fetch movies from Core Data
    private func fetchMoviesFromLocal() -> [Movie] {
        localDataRepository.fetchMovies()
    }
    
    // Fetch genres from Core Data
    private func fetchGenresFromLocal() -> [Genre] {
        localDataRepository.fetchGenres()
    }
    
    // Save movies to Core Data
    private func saveMoviesToLocal(_ movies: [Movie]) {
        localDataRepository.saveMovies(movies)
    }
    
    // Save genres to Core Data
    private func saveGenresToLocal(_ genres: [Genre]) {
        localDataRepository.saveGenres(genres)
    }
}



