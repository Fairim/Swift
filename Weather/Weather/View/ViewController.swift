import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    @IBOutlet weak var viewCoorButton: UIButton!
    @IBOutlet weak var viewCityButton: UIButton!
    @IBOutlet weak var checkWeatherButton: UIButton?
    
    
    @IBAction func viewCoordinates(_ sender: UIButton) {
        Task {
            do {
                let coordinates = try await networkManager.cityToCoordinatesRequest(with: "Moscow")
                print(coordinates)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func viewCity(_ sender: UIButton) {
        Task {
            do {
                try await networkManager.coordinatesToCityRequest("34", "21")
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
        super.viewDidLoad()
    }
    
}
