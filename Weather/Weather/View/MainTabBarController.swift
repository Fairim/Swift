import UIKit

final class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
    }
    
    private func configTabBar(){
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "pageForWeather") as! ViewController
        firstVC.view.backgroundColor = .yellow
        firstVC.tabBarItem.title = "First VC"
        firstVC.tabBarItem.image = UIImage(systemName: "1.circle", withConfiguration: smallConfig)
        
        let middleVC = ViewController()
        middleVC.view.backgroundColor = .green
        middleVC.tabBarItem.title = "Middle VC"
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        firstVC.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 9
        )
        
        let firstVC1 = ViewController()
        
        middleVC.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "circle.fill",
            tag: 0,
            position: .center,
            iconSize: 7
        )
        
        firstVC1.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "circle.fill",
            tag: 0,
            position: .center,
            iconSize: 7
        )
        
        middleVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        var config = UIButton.Configuration.filled()
        config.title = ""
        config.image = UIImage(systemName: "list.bullet")
        let buttonList = UIButton(configuration: config)
        buttonList.tintColor = UIColor.white
        
        let firstNav = UINavigationController(rootViewController: firstVC)
        let middleNav = UINavigationController(rootViewController: middleVC)
        let firstNav1 = UINavigationController(rootViewController: firstVC1)
        
        self.viewControllers = [firstNav, middleNav, firstNav1]
        self.tabBar.isTranslucent = false
        buttonList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonList)
        NSLayoutConstraint.activate([
            buttonList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(10))
            
        ])
    }
    
    private func createAllBarBottomItem() -> [UIBarButtonItem] {
        //Здесь будет реализация создание центрального Toolbar в зависимости от количества сохраненных городов
        return []
    }
    
    @objc private func allCityListTapped() {
        print("Show all list")
    }
}
