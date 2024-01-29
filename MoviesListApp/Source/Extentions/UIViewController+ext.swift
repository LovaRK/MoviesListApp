//
//  UIViewController+ext.swift
//  MoviesListApp
//
//  Created by MA1424 on 28/01/24.
//

import UIKit

protocol NetworkStatusObservable {
    func setupNetworkMonitoring()
    func removeNetworkMonitoring()
}


extension UIViewController: NetworkStatusObservable {

    private struct AssociatedKeys {
        static var NetworkStatusChangeHandler = "NetworkStatusChangeHandler"
    }

    var networkStatusChangedHandler: ((Bool) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NetworkStatusChangeHandler) as? (Bool) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.NetworkStatusChangeHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setupNetworkMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkChange(_:)),
            name: .networkStatusChanged,
            object: nil
        )
    }

    @objc private func handleNetworkChange(_ notification: Notification) {
        if let status = notification.userInfo?["Status"] as? NetworkStatus {
            let isConnected = status == .connectedViaWiFi || status == .connectedViaCellular
            DispatchQueue.main.async {
                self.networkStatusChangedHandler?(isConnected)
            }
        }
    }

    func removeNetworkMonitoring() {
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }
}


