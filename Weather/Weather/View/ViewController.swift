import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    @IBOutlet weak var viewCoorButton: UIButton!
    @IBOutlet weak var viewCityButton: UIButton!
    @IBOutlet weak var checkWeatherButton: UIButton?
    private let showWeatherNow = UIButton(type: .system)
    private let showWeatherHourly = UIButton(type: .system)
    private let showWeatherWeak = UIButton(type: .system)
    
    
    @IBAction func viewCoordinates(_ sender: UIButton) {
        Task {
            do {
                let coordinates = try await networkManager.cityToCoordinatesRequest(with: "Москва")
                print(coordinates)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func viewCity(_ sender: UIButton) {
        Task {
            do {
                try await networkManager.coordinatesToCityRequest("55.7540584", "37.62049")
                print(networkManager.takeCity())
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func checkWeather(_ sender: Any) {
        Task {
            do {
                try await networkManager.weatherRequest()
                try print(networkManager.getWeather())
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        showWeatherNow.setTitle("Показать погоду сейчас", for: .normal)
        showWeatherHourly.setTitle("Показать погоду на 24 часа", for: .normal)
        showWeatherWeak.setTitle("Показать погоду на неделю", for: .normal)
        
        showWeatherNow.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        showWeatherHourly.frame = CGRect(x: 100, y: 175, width: 100, height: 50)
        showWeatherWeak.frame = CGRect(x: 100, y: 250, width: 100, height: 50)
        
        showWeatherNow.addTarget(self, action: #selector(buttonNowTapped), for: .touchUpInside)
        showWeatherHourly.addTarget(self, action: #selector(buttonHourlyTapped), for: .touchUpInside)
        showWeatherWeak.addTarget(self, action: #selector(buttonWeaklyTapped), for: .touchUpInside)
        
        view.addSubview(showWeatherNow)
        view.addSubview(showWeatherHourly)
        view.addSubview(showWeatherWeak)
    }
    
    @objc func buttonNowTapped() {
        Task {
            do {
                try await print(networkManager.fetchCurrentWeather())
            } catch {
                print(error)
            }
        }
    }
    @objc func buttonHourlyTapped() {
        Task {
            do {
                try await print(networkManager.fetchHourlyWeather24h())
            } catch {
                print(error)
            }
        }
        
    }
    @objc func buttonWeaklyTapped() {
        Task {
            do {
                try await print(networkManager.fetchWeeklyWeather())
            } catch {
                print(error)
            }
        }
    }
    
}
