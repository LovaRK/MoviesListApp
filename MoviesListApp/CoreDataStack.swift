//
//  CoreDataManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MoviesListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
