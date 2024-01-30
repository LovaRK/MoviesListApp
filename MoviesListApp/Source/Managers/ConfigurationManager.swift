//
//  ConfigurationManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 30/01/24.
//

import Foundation

enum Environment: String {
    case development = "Dev"
    case staging = "Staging"
    case production = "Prod"
}

class ConfigurationManager {
    static let shared = ConfigurationManager()
    private var environment: Environment = .development
    private var baseURL: URL?

    func setEnvironment(_ environment: Environment) {
        self.environment = environment
        loadConfiguration()
    }
    
    func getEnvironment() -> Environment {
        return self.environment
    }

    private func loadConfiguration() {
        let resourceName = environment.rawValue + "_Config" // Assuming plist names like Dev_Config.plist
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let baseURLString = config["BaseURL"] as? String,
              let url = URL(string: baseURLString) else {
            fatalError("Failed to load configuration for \(environment.rawValue)")
        }
        self.baseURL = url
    }

    func getBaseURL() -> URL {
        return baseURL ?? URL(string: "")!
    }
}


