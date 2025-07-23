//
//  SplashViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 07/06/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let splashView = SplashView()

    override func loadView() {
        self.view = splashView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Aguarda 2 segundos após a splash estar na tela
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let tabBar = MainTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: false)
        }
    }
}

