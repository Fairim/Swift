import UIKit
import SwiftUI

extension Notification.Name {
    static let citiesDidChange = Notification.Name("citiesDidChange")
}

final class MainTabBarController: UITabBarController{
    let networkManager = NetworkManager.shared
    private let citiesManager = ListCityStorageManager.shared
    private var buttonList: UIButton?
    private var needsTabReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTabsNotification), name: .citiesDidChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if needsTabReload {
            reloadTabs()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configTabBar(){
        let placeholderLocationNav = createLocationFallbackController()
        self.setViewControllers([placeholderLocationNav], animated: false)
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        
        var config = UIButton.Configuration.filled()
        config.title = ""
        config.image = UIImage(systemName: "list.bullet")
        
        let buttonList = UIButton(configuration: config)
        buttonList.tintColor = UIColor(red: 0.11, green: 0.1, blue: 0.2, alpha: 0.92)
        self.tabBar.isTranslucent = true
        buttonList.translatesAutoresizingMaskIntoConstraints = false
        buttonList.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        tabBar.addSubview(buttonList)
        self.buttonList = buttonList
        NSLayoutConstraint.activate([
            buttonList.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -15),
            buttonList.widthAnchor.constraint(equalToConstant: 50),
            buttonList.heightAnchor.constraint(equalToConstant: 36),
            buttonList.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -25)
        ])

        reloadTabs()
    }
    
    @objc private func listButtonTapped() {
        let vc = UIHostingController(rootView: ListCityiesView())
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true)
    }

    @objc private func reloadTabsNotification() {
        needsTabReload = true

        if presentedViewController == nil && view.window != nil {
            reloadTabs()
        }
    }

    private func reloadTabs() {
        Task {
            let controllers = await buildViewControllers()
            await MainActor.run {
                self.needsTabReload = false
                self.setViewControllers(controllers, animated: false)
                self.tabBar.setNeedsLayout()
                self.tabBar.layoutIfNeeded()
                if let buttonList = self.buttonList {
                    self.tabBar.bringSubviewToFront(buttonList)
                }
            }
        }
    }

    private func buildViewControllers() async -> [UINavigationController] {
        var controllers: [UINavigationController] = []
        var currentLocationCityName = ""

        do {
            let locationController = try await showCurrentLocationWeather()
            if let fullWeatherView = (locationController.viewControllers.first as? UIHostingController<FullWeatherView>)?.rootView {
                currentLocationCityName = fullWeatherView.currentWeather.city
            }
            controllers.append(locationController)
        } catch {
            controllers.append(createLocationFallbackController())
        }

        let savedCities = citiesManager.fetchAllCities().filter { city in
            guard
                let name = city.name?.trimmingCharacters(in: .whitespacesAndNewlines),
                !name.isEmpty
            else {
                return false
            }

            if currentLocationCityName.isEmpty {
                return true
            }

            return name.caseInsensitiveCompare(currentLocationCityName) != .orderedSame
        }

        let extraControllers = await createSavedCityControllers(from: savedCities)
        controllers.append(contentsOf: extraControllers)

        return controllers
    }
    
    private func showCurrentLocationWeather() async throws -> UINavigationController{
        try await networkManager.weatherRequest()
        let currWeather = try await networkManager.fetchCurrentWeather()
        let mHourlyWeather = try await networkManager.fetchHourlyWeather24h()
        let mDailyWeather = try await networkManager.fetchWeeklyWeather()
        let weatherUISwift = FullWeatherView(currentWeather: currWeather, masHourlyWeather: mHourlyWeather, masDailyWeather: mDailyWeather)
        let weatherHostingController = UIHostingController(rootView: weatherUISwift)
        weatherHostingController.view.backgroundColor = .clear
        let weatherNav = UINavigationController(rootViewController: weatherHostingController)
        weatherNav.view.backgroundColor = .clear
        weatherNav.navigationBar.backgroundColor = .clear
        weatherNav.setNavigationBarHidden(true, animated: false)
        weatherNav.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 12
        )
        return weatherNav
    }

    private func createSavedCityControllers(from cities: [CityListToolbar]) async -> [UINavigationController] {
        var controllers: [UINavigationController] = []
        let total = cities.count

        for (index, city) in cities.enumerated() {
            let position = tabPositionForSavedCity(at: index, total: total)
            let controller = await savedCityController(for: city, index: index + 1, position: position)
            controllers.append(controller)
        }

        return controllers
    }

    private func savedCityController(for city: CityListToolbar, index: Int, position: TabPosition) async -> UINavigationController {
        do {
            try await networkManager.weatherRequest(String(city.lat), String(city.lon), fallbackCity: city.name)
            let currentWeather = try await networkManager.fetchCurrentWeather()
            let hourlyWeather = try await networkManager.fetchHourlyWeather24h()
            let dailyWeather = try await networkManager.fetchWeeklyWeather()
            let weatherView = FullWeatherView(
                currentWeather: currentWeather,
                masHourlyWeather: hourlyWeather,
                masDailyWeather: dailyWeather
            )
            let hostingController = UIHostingController(rootView: weatherView)
            hostingController.view.backgroundColor = .clear
            let navigationController = UINavigationController(rootViewController: hostingController)
            navigationController.view.backgroundColor = .clear
            navigationController.navigationBar.backgroundColor = .clear
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.tabBarItem = CustomTabBarItem(
                title: "",
                imageName: "circle.fill",
                tag: index,
                position: position,
                iconSize: 10
            )
            return navigationController
        } catch {
            return createSavedCityFallbackController(tag: index, position: position)
        }
    }
    
    private func createLocationFallbackController() -> UINavigationController {
        let fallbackController = UIViewController()
        fallbackController.view.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: fallbackController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "location.fill",
            tag: 0,
            position: .center,
            iconSize: 12
        )
        return navigationController
    }

    private func createSavedCityFallbackController(tag: Int, position: TabPosition) -> UINavigationController {
        let fallbackController = UIViewController()
        fallbackController.view.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: fallbackController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.tabBarItem = CustomTabBarItem(
            title: "",
            imageName: "circle.fill",
            tag: tag,
            position: position,
            iconSize: 10
        )
        return navigationController
    }

    private func tabPositionForSavedCity(at index: Int, total: Int) -> TabPosition {
        .center
    }
    
    private func createAllBarBottomItem() -> [UIBarButtonItem] {
        //Здесь будет реализация создание центрального Toolbar в зависимости от количества сохраненных городов
        return []
    }
    
    @objc private func allCityListTapped() {
        print("Show all list")
    }
}
