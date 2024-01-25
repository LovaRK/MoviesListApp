//
//  GenreEntity+CoreDataProperties.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//
//

import Foundation
import CoreData


extension GenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
        return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension GenreEntity : Identifiable {

}
