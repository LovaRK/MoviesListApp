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





//{
//  "page": 1,
//  "results": [
//    {
//      "adult": false,
//      "backdrop_path": "/rz8GGX5Id2hCW1KzAIY4xwbQw1w.jpg",
//      "genre_ids": [
//        28,
//        35,
//        80
//      ],
//      "id": 955916,
//      "original_language": "en",
//      "original_title": "Lift",
//      "overview": "An international heist crew, led by Cyrus Whitaker, race to lift $500 million in gold from a passenger plane at 40,000 feet.",
//      "popularity": 2025.03,
//      "poster_path": "/gma8o1jWa6m0K1iJ9TzHIiFyTtI.jpg",
//      "release_date": "2024-01-10",
//      "title": "Lift",
//      "video": false,
//      "vote_average": 6.3,
//      "vote_count": 338
//    },
//    {
//      "adult": false,
//      "backdrop_path": "/bmlkLCjrIWnnZzdAQ4uNPG9JFdj.jpg",
//      "genre_ids": [
//        35,
//        10751,
//        14
//      ],
//      "id": 787699,
//      "original_language": "en",
//      "original_title": "Wonka",
//      "overview": "Willy Wonka – chock-full of ideas and determined to change the world one delectable bite at a time – is proof that the best things in life begin with a dream, and if you’re lucky enough to meet Willy Wonka, anything is possible.",
//      "popularity": 838.639,
//      "poster_path": "/qhb1qOilapbapxWQn9jtRCMwXJF.jpg",
//      "release_date": "2023-12-06",
//      "title": "Wonka",
//      "video": false,
//      "vote_average": 7.1,
//      "vote_count": 1083
//    },
//    {
//      "adult": false,
//      "backdrop_path": "/AprNYUAS2AJ3xVgg7Wwt00GVvsM.jpg",
//      "genre_ids": [
//        16,
//        10751,
//        28,
//        878,
//        35,
//        18,
//        12
//      ],
//      "id": 893723,
//      "original_language": "en",
//      "original_title": "PAW Patrol: The Mighty Movie",
//      "overview": "A magical meteor crash lands in Adventure City and gives the PAW Patrol pups superpowers, transforming them into The Mighty Pups.",
//      "popularity": 245.483,
//      "poster_path": "/aTvePCU7exLepwg5hWySjwxojQK.jpg",
//      "release_date": "2023-09-21",
//      "title": "PAW Patrol: The Mighty Movie",
//      "video": false,
//      "vote_average": 7.1,
//      "vote_count": 290
//    }
//  ],
//  "total_pages": 6317,
//  "total_results": 126331
//}
