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
        self.setupAPIKeysToKeychain()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.chooseInitialViewController()
    }
    
    private func setupAPIKeysToKeychain() {
        // Example usage to store the API Key
        let apiKey = "4fafde19e120ff8f6ef8e1106f0e614c"
        if let apiKeyData = apiKey.data(using: .utf8) {
            KeychainService.save(key: "APIKey", data: apiKeyData)
        }
        
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ZmFmZGUxOWUxMjBmZjhmNmVmOGUxMTA2ZjBlNjE0YyIsInN1YiI6IjVjNmJmM2I4YzNhMzY4NWNiZGRjOTBlZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VselLryELvHnWq3Mph2hbJpnTbBc8Py0UmjtOiZpt0M"
        if let accessTokenData = accessToken.data(using: .utf8) {
            KeychainService.save(key: "AccessToken", data: accessTokenData)
        }
        
    }
    
    private func chooseInitialViewController() {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        let viewController = initialViewControllerProvider.provideInitialViewController()
        sceneDelegate.changeRootViewController(viewController)
    }
}


