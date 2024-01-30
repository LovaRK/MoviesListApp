//
//  APIManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 16/01/24.
//

import Foundation

protocol APIManagerProtocal {
    func request<T: Decodable>(route: URLRoute, completion: @escaping (Result<T, APIError>) -> Void)
}

class APIManager: APIManagerProtocal {
    // Define default headers here
    
    private var defaultHeaders: [String: String] {
        var headers = ["Accept": "application/json"]
        if let accessToken = KeychainService.load(key: "APIKey") {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return headers
    }
    
    func request<T: Decodable>(route: URLRoute, completion: @escaping (Result<T, APIError>) -> Void) {
        var components = URLComponents(url: route.baseURL.appendingPathComponent(route.path), resolvingAgainstBaseURL: false)
        components?.queryItems = route.parameters?.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        guard let url = components?.url else {
            DispatchQueue.main.async {
                completion(.failure(.wrongURL))
            }
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = route.method.rawValue
        // Merge default headers with route-specific headers
        var allHeaders = defaultHeaders
        if let routeHeaders = route.headers {
            allHeaders.merge(routeHeaders) { (_, new) in new }
        }
        // Set all headers in the URLRequest
        for (key, value) in allHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        print("Here is the URL:::::::::::\(url)")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.httpError(httpResponse.statusCode))) // Use the correct error case
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(.connectionError))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataNotFound))
                }
                return
            }
            do {
                //                let responseDataString = String(data: data, encoding: .utf8)
                //                print("Response JSON string: \(String(describing: responseDataString))")
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.jsonParsingError))
                }
            }
        }
        task.resume()
    }
}

