//
//  MainTabBarController.swift
//  MoviesListApp
//
//  Created by MA1424 on 13/01/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    static func setUpTabBar() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        // Set up Tab Bar Appearance
        let tabBarAppearance = TabBarAppearanceCustomizer.customize()
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        // Setup View Controllers
        tabBarController.setupViewControllers()
        self.setupNavBar()
        return tabBarController
    }
    
    static func setLoginVC() -> UIViewController {
        self.setupNavBar()
        return UINavigationController(rootViewController: LoginVc())
    }
    
    static func setupNavBar(){
        let navBarController = UINavigationController()
        UINavigationBar.appearance().prefersLargeTitles = true // Enable large titles
        let navbarAppearance = NavigationBarAppearanceCustomizer.customize()
        // navbarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navBarController.navigationBar.standardAppearance = navbarAppearance
        if #available(iOS 15.0, *) {
            navBarController.navigationBar.scrollEdgeAppearance = navbarAppearance
        }
    }
    
    private func setupViewControllers() {
        // Create an instance of APIManager and MoviesAPIService
        let apiManager = APIManager()
        let localDataRepository = CoreDataRepository()
        
        let moviesAPIService = MoviesAPIService(apiManager: apiManager, localDataRepository: localDataRepository)
        
        // Initializing view models with specific fetch functions
        let movieHomeVM = MovieHomeViewModel(apiService: moviesAPIService)
        // Example of how to initialize the ViewModel
        let popularViewModel = MoviesListViewModel(apiService: moviesAPIService, category: .popular)
        let topRatedViewModel = MoviesListViewModel(apiService: moviesAPIService, category: .topRated)
        let upcomingViewModel = MoviesListViewModel(apiService: moviesAPIService, category: .upcoming)

        
        // Creating navigation controllers for each category
        let homeVC = UINavigationController(rootViewController: MovieHomeVC(viewModel: movieHomeVM))
        let popularVC = UINavigationController(rootViewController: MoviesListVC(viewModel: popularViewModel, title: "Popular"))
        let topRatedVC = UINavigationController(rootViewController: MoviesListVC(viewModel: topRatedViewModel, title: "Top Rated"))
        let upcomingVC = UINavigationController(rootViewController: MoviesListVC(viewModel: upcomingViewModel, title: "Upcoming"))
        
        // Setting tab bar items
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        popularVC.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "star.fill"), tag: 1)
        topRatedVC.tabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(systemName: "hand.thumbsup.fill"), tag: 2)
        upcomingVC.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "calendar"), tag: 3)
        
        // Setting the array of root view controllers for the tab bar controller
        setViewControllers([homeVC, popularVC, topRatedVC, upcomingVC], animated: true)
    }

    
    struct TabBarAppearanceCustomizer {
        static func customize() -> UITabBarAppearance {
            let appearance = UITabBarAppearance()
            if #available(iOS 15.0, *) {
                // Customize Tab Bar Appearance for iOS 15 and later
                appearance.backgroundColor = .systemBackground
                appearance.stackedLayoutAppearance.selected.iconColor = .label
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.label]
            } else {
                // Customize for earlier versions
            }
            return appearance
        }
    }
    
    struct NavigationBarAppearanceCustomizer {
        static func customize() -> UINavigationBarAppearance {
            let appearance = UINavigationBarAppearance()
            
            // Customize appearance
            appearance.backgroundColor = .systemBackground  // or any color you prefer
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]  // Title color
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]  // Large title color
            
            // Apply appearance to all navigation bars
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance // For smaller navigation bars
            if #available(iOS 15.0, *) {
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
            return appearance
        }
    }
}

