//
//  UserSession.swift
//  MoviesListApp
//
//  Created by MA1424 on 13/01/24.
//

import UIKit

protocol UserSession {
    func isUserLoggedIn() -> Bool
}

class DefaultUserSession: UserSession {
    func isUserLoggedIn() -> Bool {
        // Add the actual user login logic
        return true
    }
}

protocol InitialViewControllerProviding {
    func provideInitialViewController() -> UIViewController
}

class DefaultInitialViewControllerProvider: InitialViewControllerProviding {
    private let userSession: UserSession
    
    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    func provideInitialViewController() -> UIViewController {
        if userSession.isUserLoggedIn() {
            return MainTabBarController.setUpTabBar()
        } else {
            return MainTabBarController.setLoginVC()
        }
    }
}
