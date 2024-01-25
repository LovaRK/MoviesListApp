//
//  UIDevice+ext.swift
//  MoviesListApp
//
//  Created by MA1424 on 13/01/24.
//

import UIKit

extension UIDevice {
    
    enum DeviceInterfaceType {
        case dynamicIsland, notch, none
    }
    
    var interfaceType: DeviceInterfaceType {
        guard let window = UIWindow.key else {
            return .none
        }
        
        if window.safeAreaInsets.top >= 51 && userInterfaceIdiom == .phone {
            return .dynamicIsland
        } else if window.safeAreaInsets.top >= 44 {
            return .notch
        } else if window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0 {
            return .none
        }
        
        return .none
    }
    
    /// Returns `true` if the device has a notch or a Dynamic Island
    var hasNotchOrDynamicIsland: Bool {
        return interfaceType == .notch || interfaceType == .dynamicIsland
    }
}



extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            if #available(iOS 15, *){
                return UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
                
            } else {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}


extension UIColor {
    // Setup custom colours we can use throughout the app using hex values
    
    // Create a UIColor from RGB
    public convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
