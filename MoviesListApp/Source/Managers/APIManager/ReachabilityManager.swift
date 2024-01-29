//
//  ReachabilityManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 27/01/24.
//

import Network
import Foundation

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("ReachabilityManager.networkStatusChanged")
}

enum NetworkStatus {
    case connectedViaWiFi
    case connectedViaCellular
    case notConnected
}

class ReachabilityManager {
    static let shared = ReachabilityManager()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    var currentStatus: NetworkStatus = .notConnected
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            switch path.status {
            case .satisfied:
                if path.usesInterfaceType(.wifi) {
                    self.currentStatus = .connectedViaWiFi
                } else if path.usesInterfaceType(.cellular) {
                    self.currentStatus = .connectedViaCellular
                }
            case .unsatisfied, .requiresConnection:
                self.currentStatus = .notConnected
            @unknown default:
                break
            }
            
            print("Network Status: \(self.currentStatus)")
            NotificationCenter.default.post(name: .networkStatusChanged, object: self, userInfo: ["Status": self.currentStatus])
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}




/*
 
 // Usage in another part of the app
 NotificationCenter.default.addObserver(
 forName: .networkStatusChanged,
 object: nil,
 queue: .main
 ) { notification in
 if let status = notification.userInfo?["Status"] as? NetworkStatus {
 switch status {
 case .connectedViaWiFi:
 print("Connected via WiFi")
 case .connectedViaCellular:
 print("Connected via Cellular")
 case .notConnected:
 print("Not connected to the Internet")
 }
 }
 }
 
 */
