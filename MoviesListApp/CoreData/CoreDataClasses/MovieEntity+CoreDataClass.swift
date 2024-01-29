//
//  MovieEntity+CoreDataClass.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    static func from(movie: Movie, context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.update(with: movie)
        return entity
    }
    
    func update(with movie: Movie) {
        self.id = Int64(movie.id ?? 0)
        self.adult = movie.adult ?? false
        self.backdropPath = movie.backdropPath ?? ""
        self.originalLanguage = movie.originalLanguage?.rawValue
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.popularity = movie.popularity ?? 0
        self.posterPath = movie.posterPath
        self.title = movie.title
        self.video = movie.video ?? false
        self.voteAverage = movie.voteAverage ?? 0
        self.voteCount = Int64(movie.voteCount ?? 0)
        
        // Handle the release date conversion if necessary
        if let releaseDateString = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this format to match your date string
            self.releaseDate = dateFormatter.date(from: releaseDateString)
        } else {
            self.releaseDate = Date(timeIntervalSince1970: 0) // Example: Jan 1, 1970
        }
        
        // Handle the genres relationship
        // Assuming GenreEntity exists and has an 'id' attribute
        if let genreIDs = movie.genreIDS {
            let genreEntities = genreIDs.compactMap { genreID -> GenreID? in
                let fetchRequest: NSFetchRequest<GenreID> = GenreID.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(genreID))
                return try? self.managedObjectContext?.fetch(fetchRequest).first
            }
            let genresSet = NSSet(array: genreEntities)
            self.genres = genresSet
        }
    }
}
