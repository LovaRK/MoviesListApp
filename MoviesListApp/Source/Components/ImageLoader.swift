//
//  ImageLoader.swift
//  MoviesListApp
//
//  Created by MA1424 on 16/01/24.
//

import UIKit

class ImageLoader {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    
    private static var runningRequests = [UUID: URLSessionDataTask]()

    static func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        guard let urlPath = Utils.getEnvironmentValue(forKey: "posterPath") else {
            completion(.failure(ImageLoaderError.missingPosterPath))
            return nil
        }
        
        let url = urlPath + urlString
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return nil
        }
        
        guard let imageURL = URL(string: url) else {
            completion(.failure(ImageLoaderError.invalidURL))
            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            defer { runningRequests.removeValue(forKey: uuid) }

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(ImageLoaderError.invalidData))
                }
                return
            }

            imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()

        runningRequests[uuid] = task
        return uuid
    }

    static func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }

    enum ImageLoaderError: Error {
        case invalidURL
        case invalidData
        case missingPosterPath
    }
}



