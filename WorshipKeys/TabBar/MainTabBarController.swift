//
//  MainTabBarController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 11/04/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = UIColor(hex: "#0A0A0A")
    }
    
    private func setupViewControllers(){
        
        let fxVC = UIViewController()
        fxVC.view.backgroundColor = .black
        fxVC.tabBarItem = UITabBarItem(title: "Setlist", image: UIImage(systemName: "music.note.list"), tag: 0)
        
        let homeVC = MainPadViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Pads", image: UIImage(systemName: "lightspectrum.horizontal"), tag: 1)
        
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .black
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
        
        viewControllers = [fxVC, homeVC, settingsVC]
        selectedIndex = 1
    }

}
