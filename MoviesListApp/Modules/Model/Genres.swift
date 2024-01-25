//
//  Genres.swift
//  MoviesListApp
//
//  Created by MA1424 on 14/01/24.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}


extension Genre {
    init(from entity: GenreEntity) {
        self.id = Int(entity.id)
        self.name = entity.name
        // Map other properties from GenreEntity to Genre
    }
}
