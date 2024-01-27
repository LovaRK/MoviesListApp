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
    func getMovieEntity(byId id: Int, context: NSManagedObjectContext) -> MovieEntity?
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
    
    func getMovieEntity(byId id: Int, context: NSManagedObjectContext) -> MovieEntity? {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try coreDataHelper.mainManagedObjectContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching movie with id \(id): \(error)")
            return nil
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        coreDataHelper.performBackgroundTask { context in
            for movie in movies {
                // Check if a MovieEntity with the same ID already exists
                if self.getMovieEntity(byId: movie.id ?? 0, context: context) == nil {
                    // Create a new MovieEntity
                    let newMovieEntity = MovieEntity(context: context)
                    newMovieEntity.update(with: movie)
                } else {
                    // Update existing entity no need to update this type of data
                    // print("Update existing entity no need to update this type of data")
                    // movieEntity.update(with: movie)
                }
            }
            self.coreDataHelper.saveChanges()
        }
    }
    
    func getGenreEntity(byId id: Int, context: NSManagedObjectContext) -> GenreEntity? {
        let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try coreDataHelper.mainManagedObjectContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching Genre with id \(id): \(error)")
            return nil
        }
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
        coreDataHelper.performBackgroundTask { context in
            for genre in genres {
                // Check if a getGenreEntity with the same ID already exists
                let genreEntity = self.getGenreEntity(byId: genre.id ?? 0, context: context)
                ?? GenreEntity(context: context)
                // Update the properties of the getGenreEntity with data from the genre
                genreEntity.update(with: genre)
            }
            self.coreDataHelper.saveChanges()
        }
    }
}
