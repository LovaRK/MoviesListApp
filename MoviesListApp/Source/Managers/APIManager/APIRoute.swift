//
//  APIRoute.swift
//  MoviesListApp
//
//  Created by MA1424 on 23/01/24.
//

import Foundation

protocol URLRoute {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

enum APIRoute: URLRoute {
    case fetchGenres
    case fetchMovies(genreId: Int, page: Int)
    case fetchPopularMovies(page: Int)
    case fetchTopRatedMovies(page: Int)
    case fetchUpcomingMovies(page: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "/genre/movie/list"
        case .fetchMovies:
            return "/discover/movie"
        case .fetchPopularMovies:
            return "/movie/popular"
        case .fetchTopRatedMovies:
            return "/movie/top_rated"
        case .fetchUpcomingMovies:
            return "/movie/upcoming"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchGenres:
            // Parameters for fetchGenres case
            var params: [String: Any] = [:]
            
            // Get the API key
            if let apiKey = Utils.getEnvironmentValue(forKey: "APIKey") {
                params["api_key"] = apiKey
            }
            params["language"] = "en-US"
            
            return params
        case .fetchMovies(let genreId, let page):
            // Parameters for fetchMovies case with genreId
            var params: [String: Any] = [:]
            
            // Get the API key
            if let apiKey = Utils.getEnvironmentValue(forKey: "APIKey") {
                params["api_key"] = apiKey
            }
            
            // Set common parameters
            params["language"] = "en-US"
            
            // Add genreId if provided
            params["with_genres"] = "\(genreId)"
            
            params["page"] = "\(page)"
            
            return params.isEmpty ? nil : params
        case .fetchPopularMovies(let page), .fetchTopRatedMovies(let page), .fetchUpcomingMovies(let page):
            var params: [String: Any] = [:]
            params["page"] = "\(page)"
            return params
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchGenres:
            // Headers for fetchGenres case
            return nil
        case .fetchMovies:
            // Headers for fetchMovies case
            return nil
        case .fetchPopularMovies(_), .fetchTopRatedMovies(_), .fetchUpcomingMovies(_):
            // Headers for fetchPopularMovies
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
    
}
