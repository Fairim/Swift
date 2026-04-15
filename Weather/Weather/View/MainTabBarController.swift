import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController{
    let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
    }
    
    private func configTabBar(){
        let placeholderLocationNav = createLocationFallbackController()
        self.setViewControllers([placeholderLocationNav], animated: false)
        
        Task {
            let locationNav: UINavigationController
            do {
                locationNav = try await showCurrentLocationWeather()
            } catch {
                print("Не удалось создать экран погоды по локации: \(error)")
                locationNav = createLocationFallbackController()
            }
            
            await MainActor.run {
                self.setViewControllers([locationNav], animated: false)
            }
        }
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        
        var config = UIButton.Configuration.filled()
        config.title = ""
        config.image = UIImage(systemName: "list.bullet")
        
        let buttonList = UIButton(configuration: config)
        buttonList.tintColor = UIColor(red: 0.11, green: 0.1, blue: 0.2, alpha: 0.92)
        self.tabBar.isTranslucent = false
        buttonList.translatesAutoresizingMaskIntoConstraints = false
        buttonList.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        view.addSubview(buttonList)
        NSLayoutConstraint.activate([
            buttonList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(30)),
            buttonList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func listButtonTapped() {
        let vc = UIHostingController(rootView: ListCityiesView())
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true)
    }
    
    private func showCurrentLocationWeather() async throws -> UINavigationController{
        try await networkManager.weatherRequest()
        let currWeather = try await networkManager.fetchCurrentWeather()
        let mHourlyWeather = try await networkManager.fetchHourlyWeather24h()
        let mDailyWeather = try await networkManager.fetchWeeklyWeather()
        let weatherUISwift = FullWeatherView(currentWeather: currWeather, masHourlyWeather: mHourlyWeather, masDailyWeather: mDailyWeather)
        let weatherHostingController = UIHostingController(rootView: weatherUISwift)
        let weatherNav = UINavigationController(rootViewController: weatherHostingController)
        weatherNav.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 12
        )
        return weatherNav
    }
    
    private func createLocationFallbackController() -> UINavigationController {
        let fallbackController = UIViewController()
        fallbackController.view.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: fallbackController)
        navigationController.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 12
        )
        return navigationController
    }
    
    private func createAllBarBottomItem() -> [UIBarButtonItem] {
        //Здесь будет реализация создание центрального Toolbar в зависимости от количества сохраненных городов
        return []
    }
    
    @objc private func allCityListTapped() {
        print("Show all list")
    }
}
