//
//  MainTabBarController.swift
//  Weather
//
//  Created by Jorgen Boring on 28/02/2026.
//

import UIKit

final class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
    }
    
    private func configTabBar(){
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let firstVC = ViewController()
        firstVC.view.backgroundColor = .yellow
        firstVC.tabBarItem.title = "First VC"
        firstVC.tabBarItem.image = UIImage(systemName: "1.circle", withConfiguration: smallConfig)

        // 2
        let middleVC = ViewController()
        middleVC.view.backgroundColor = .green
        middleVC.tabBarItem.title = "Middle VC"

        // 3
        let secondVC = ViewController()
        secondVC.view.backgroundColor = .blue
        secondVC.tabBarItem.title = "Second VC"
        secondVC.tabBarItem.image = UIImage(systemName: "2.circle", withConfiguration: smallConfig)
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        firstVC.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 7
        )
        
        firstVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        middleVC.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "circle.fill",
            tag: 0,
            position: .center,
            iconSize: 7
        )
        
        middleVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        secondVC.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "list.bullet",
            tag: 0,
            position: .right
        )
        
        
        let firstNav = UINavigationController(rootViewController: firstVC)
        let secondNav = UINavigationController(rootViewController: secondVC)
        let middleNav = UINavigationController(rootViewController: middleVC)
        
        self.viewControllers = [firstNav, secondNav, middleNav]
        self.tabBar.isTranslucent = false
    }
    
    private func createAllBarBottomItem() -> [UIBarButtonItem] {
        //Здесь будет реализация создание центрального Toolbar в зависимости от количества сохраненных городов
        return []
    }
    
    @objc private func allCityListTapped() {
        print("Show all list")
    }
}
