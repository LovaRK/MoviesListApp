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
    func fetchMovies(forGenre genreId: Int, page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    func fetchPopularMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    func fetchTopratedMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<Movies, APIError>) -> Void)
    
}

class MoviesAPIService: APIService {
    
    private let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchGenres(completion: @escaping (Result<Genres, APIError>) -> Void) {
        apiManager.request(route: APIRoute.fetchGenres) { (result: Result<Genres, APIError>) in
            switch result {
            case .success(let genres):
                completion(.success(genres))
            case .failure:
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    // Implement other methods similarly...
    
    func fetchMovies(forGenre genreId: Int, page: Int, completion: @escaping (Result<Movies, APIError>) -> Void) {
        apiManager.request(route: APIRoute.fetchMovies(genreId: genreId, page: page)) { (result: Result<Movies, APIError>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure:
                completion(.failure(.dataNotFound))
            }
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



