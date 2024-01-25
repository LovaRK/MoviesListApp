//
//  APIError.swift
//  MoviesListApp
//
//  Created by MA1424 on 23/01/24.
//

import Foundation

// APIError Enum
enum APIError: Error {
    case connectionError
    case dataNotFound
    case jsonParsingError
    case httpError(Int)  // Add a case for HTTP errors with status code
    case wrongURL
}

// URLRoute Protocol
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    // Add other methods as needed.
}
