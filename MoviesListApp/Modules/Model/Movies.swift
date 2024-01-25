//
//  Movies.swift
//  MoviesListApp
//
//  Created by MA1424 on 14/01/24.
//

import Foundation

// MARK: - Movies
struct Movies: Codable {
    let page: Int?
    let movies: [Movie]? // Changed from [Result] to [Movie]
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Codable { // Renamed from Result to Movie
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case other
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = OriginalLanguage(rawValue: rawValue) ?? .other
    }
}

extension Movie {
    init(from entity: MovieEntity) {
        self.id = Int(entity.id)
        self.adult = entity.adult
        self.backdropPath = entity.backdropPath
        self.originalLanguage = OriginalLanguage(rawValue: entity.originalLanguage ?? "") ?? .other
        self.originalTitle = entity.originalTitle
        self.overview = entity.overview
        self.popularity = entity.popularity
        self.posterPath = entity.posterPath
        self.releaseDate = entity.releaseDate?.formattedDate() // Assuming you have a method to convert Date to String
        self.title = entity.title
        self.video = entity.video
        self.voteAverage = entity.voteAverage
        self.voteCount = Int(entity.voteCount)

        // Handling genreIDS (assuming genres are stored as a set of GenreEntity)
        if let genreSet = entity.genres as? Set<GenreEntity> {
            self.genreIDS = genreSet.map { Int($0.id) }
        } else {
            self.genreIDS = []
        }
    }
}

extension Date {
    func formattedDate(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

