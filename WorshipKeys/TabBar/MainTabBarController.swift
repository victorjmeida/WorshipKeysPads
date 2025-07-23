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
        tabBar.backgroundColor = UIColor(hex: "#0B0B0B")
    }
    
    private func setupViewControllers(){
        
        let setlistVC = SetlistViewController()
        let setlistNav = UINavigationController(rootViewController: setlistVC)
        setlistNav.tabBarItem = UITabBarItem(title: "Setlist", image: UIImage(systemName: "music.note.list"), tag: 0)
        
        let homeVC = UINavigationController(rootViewController: MainPadViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Pads", image: UIImage(systemName: "lightspectrum.horizontal"), tag: 1)

        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)

        
        viewControllers = [setlistNav, homeVC, settingsVC]
        selectedIndex = 1
    }

}
