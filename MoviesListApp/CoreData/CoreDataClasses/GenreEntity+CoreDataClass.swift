//
//  GenreEntity+CoreDataClass.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//
//

import Foundation
import CoreData

@objc(GenreEntity)
public class GenreEntity: NSManagedObject {
    
    static func from(genre: Genre, context: NSManagedObjectContext) -> GenreEntity {
        let entity = GenreEntity(context: context)
        entity.update(with: genre)
        return entity
    }
    
    func update(with genre: Genre) {
        self.id = Int64(genre.id ?? 0)
        self.name = genre.name
    }
}
