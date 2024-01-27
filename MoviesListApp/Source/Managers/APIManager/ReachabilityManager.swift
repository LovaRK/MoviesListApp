//
//  ReachabilityManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 27/01/24.
//

import Foundation
import Network

class ReachabilityManager {

    static let shared = ReachabilityManager()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    var connectionType: NWInterface.InterfaceType? {
        return monitor.currentPath.availableInterfaces.filter { monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }

    var onNetworkStatusChange: ((Bool) -> Void)?

    init() {
        monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.onNetworkStatusChange?(path.status == .satisfied)
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}

//============ HOW TO USE THIS =====================\\

//Subscribing to Network Changes:

/*

ReachabilityManager.shared.onNetworkStatusChange = { isConnected in
    if isConnected {
        print("Internet is available")
        // Perform actions when the internet is available
    } else {
        print("Internet is unavailable")
        // Perform actions when the internet is unavailable
    }
}
 
 */


// Checking Current Connectivity and Type:

/*
 
 if ReachabilityManager.shared.isConnected {
     if let connectionType = ReachabilityManager.shared.connectionType {
         switch connectionType {
         case .wifi:
             print("Connected via WiFi")
         case .cellular:
             print("Connected via Cellular")
         default:
             print("Other Connection Type")
         }
     }
 } else {
     print("No internet connection")
 }

 */


// =============================================


