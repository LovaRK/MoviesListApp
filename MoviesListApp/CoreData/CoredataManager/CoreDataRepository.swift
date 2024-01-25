//
//  CoreDataRepository.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//

import Foundation
import CoreData

protocol LocalDataRepository {
    func fetchMovies() -> [Movie]
    func saveMovies(_ movies: [Movie])
    func fetchGenres() -> [Genre]
    func saveGenres(_ genres: [Genre])
}

class CoreDataRepository: LocalDataRepository {
    private let coreDataHelper = CoreDataHelper.shared
    
    func fetchMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try coreDataHelper.mainManagedObjectContext.fetch(fetchRequest)
            return movieEntities.map { Movie(from: $0) } // Assuming Movie has an initializer that takes MovieEntity
        } catch {
            print("Error fetching movies from local storage: \(error)")
            return []
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        let movieEntities = movies.map { MovieEntity.from(movie: $0, context: coreDataHelper.privateManagedObjectContext) }
        coreDataHelper.saveData(objects: movieEntities)
    }
    
    func fetchGenres() -> [Genre] {
        let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        do {
            let genreEntities = try coreDataHelper.mainManagedObjectContext.fetch(fetchRequest)
            return genreEntities.map { Genre(from: $0) } // Assuming Genre has an initializer that takes GenreEntity
        } catch {
            print("Error fetching genres from local storage: \(error)")
            return []
        }
    }
    
    func saveGenres(_ genres: [Genre]) {
        let genreEntities = genres.map { GenreEntity.from(genre: $0, context: coreDataHelper.privateManagedObjectContext) }
        coreDataHelper.saveData(objects: genreEntities)
    }
}
