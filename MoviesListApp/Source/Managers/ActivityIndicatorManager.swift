//
//  ActivityIndicatorManager.swift
//  MoviesListApp
//
//  Created by MA1424 on 23/01/24.
//

import UIKit

class ActivityIndicatorManager<View: UIView> {
    private var containerView: UIView?
    private var loadingView: ActivityIndicatorView?

    func showActivityIndicator(on view: View) {
        guard containerView == nil else { return }

        let loadingView = ActivityIndicatorView()
        containerView = UIView(frame: view.bounds)
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView?.addSubview(loadingView)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor)
        ])

        view.addSubview(containerView!)
    }

    func hideActivityIndicator() {
        loadingView?.stopAnimating()
        containerView?.removeFromSuperview()
        containerView = nil
        loadingView = nil
    }
}
