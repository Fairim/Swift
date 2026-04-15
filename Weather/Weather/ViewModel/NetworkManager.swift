import Foundation

class NetworkManager {
    static let shared = NetworkManager(); private init() {}
    private let locationModel = LocationModel()
    private var weatherResponse: WeatherResponse?
    private let weatherService = WeatherService()
    private let geoCoderService = DaDataGeocoder()
    private let cityStorageManager = ListCityStorageManager.shared
    private var cityResponse: DaDataAddress?
    private var currentCity: String?
    private var lat: String?
    private var lon: String?
    
    func getWeather() throws -> WeatherResponse {
        guard let weather = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        return weather
    }
    
    func weatherRequest() async throws {
        do {
            let locationData = try await locationModel.getCurrentLocation()
            lat = String(locationData.coordinate.latitude)
            lon = String(locationData.coordinate.longitude)
            weatherResponse = try await weatherService.fetchWeather(lat: lat!, lon: lon!)
            currentCity = try await geoCoderService.reverseGeocode(lat: lat!, lon: lon!) ?? ""
            try saveCurrentCitySnapshot()
        } catch {
            print(error)
        }
    }
    
    func weatherRequest(_ lat: String, _ lon: String) async throws {
        do {
            self.lat = lat
            self.lon = lon
            weatherResponse = try await weatherService.fetchWeather(lat: lat, lon: lon)
            currentCity = try await geoCoderService.reverseGeocode(lat: lat, lon: lon) ?? ""
            try saveCurrentCitySnapshot()
        } catch {
            print(error)
        }
    }
    
    
    func fetchCurrentWeather() async throws -> CurrentWeather {
        guard let response = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        return response.currentWeather(city: currentCity ?? "")
    }

    func fetchHourlyWeather24h() async throws -> [HourlyWeather] {
        guard let response = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        return response.hourlyWeather24h()
    }

    func fetchWeeklyWeather() async throws -> [DailyWeather] {
        guard let response = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        return response.weeklyWeather()
    }
    
    func coordinatesToCityRequest(_ lat: String, _ lon: String) async throws {
        do {
            currentCity = try await geoCoderService.reverseGeocode(lat: lat, lon: lon)
        } catch {
            print(error)
        }
    }
    
    func cityToCoordinatesRequest(with city: String) async throws -> [Double] {
        do {
            currentCity = city
            let geo = try await geoCoderService.geocode(city: city)
            lat = String(geo.lat)
            lon = String(geo.lon)
            return [geo.lat, geo.lon]
        } catch {
            throw error
        }
    }
    
    func takeCity() -> String {
        guard let city = currentCity else {
            return ""
        }
        return city
    }
    
    private func saveCurrentCitySnapshot() throws {
        guard
            let weatherResponse,
            let lat,
            let lon,
            let latValue = Double(lat),
            let lonValue = Double(lon)
        else {
            return
        }
        
        let currentWeather = weatherResponse.currentWeather(city: currentCity ?? "")
        try cityStorageManager.upsertCity(
            cityName: currentWeather.city,
            lat: latValue,
            lon: lonValue,
            currentTemperature: currentWeather.temperature,
            currentIcon: currentWeather.icon
        )
    }
}
