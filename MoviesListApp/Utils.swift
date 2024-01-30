//
//  File.swift
//  MoviesListApp
//
//  Created by MA1424 on 18/01/24.
//

import Foundation


class Utils {
    
    static func getEnvironmentValue(forKey key: String) -> String? {
        let resourceName = ConfigurationManager.shared.getEnvironment().rawValue + "_Config" // Assuming plist names like Dev_Config.plist
        if let path = Bundle.main.path(forResource: resourceName, ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path) as? [String: Any],
           let value = keys[key] as? String {
            return value
        }
        return nil
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Adjust the date format to match the format used in `releaseDate`
        formatter.locale = Locale(identifier: "en_US_POSIX") // Use a POSIX locale to ensure consistent parsing
        return formatter
    }()
    
    static func dateFromString(_ dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    static func yearStringFromDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return String(year)
    }
}
