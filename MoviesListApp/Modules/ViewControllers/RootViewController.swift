//
//  RootViewController.swift
//  MoviesListApp
//
//  Created by MA1424 on 13/01/24.
//

import UIKit

class RootViewController: UIViewController {
    private var initialViewControllerProvider: InitialViewControllerProviding
    
    init(provider: InitialViewControllerProviding) {
        self.initialViewControllerProvider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.chooseInitialViewController()
        }
    }
    
    private func chooseInitialViewController() {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        let viewController = initialViewControllerProvider.provideInitialViewController()
        sceneDelegate.changeRootViewController(viewController)
    }
}


