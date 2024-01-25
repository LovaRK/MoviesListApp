//
//  AppDelegateServices.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//

import UIKit

class AppDelegateServices {
    static let shared = AppDelegateServices()

    func applicationDidEnterBackground() {
        CoreDataStack.shared.saveContext()
    }

    func applicationWillTerminate() {
        CoreDataStack.shared.saveContext()
    }

    // Add other app delegate related functionalities here
}
