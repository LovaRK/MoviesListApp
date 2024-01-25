//
//  GenreID+CoreDataProperties.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//
//

import Foundation
import CoreData


extension GenreID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreID> {
        return NSFetchRequest<GenreID>(entityName: "GenreID")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var movies: MovieEntity?

}

extension GenreID : Identifiable {

}
