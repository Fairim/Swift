import Foundation

class NetworkManager {
    static let shared = NetworkManager(); private init() {}
    private let locationModel = LocationModel()
    private let cityRequestModel = CityRequestModel()
    private let weatherRequestModel = WeatherRequestModel()
    private var weatherResponse: WeatherResponse?
    private var cityResponse: CityResponse?
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
            weatherResponse = try await weatherRequestModel.requestToServer(lat: lat!, lon: lon!)
        } catch {
            print(error)
        }
    }
    
    func weatherRequest(_ lat: String, _ lon: String) async throws {
        do {
            self.lat = lat
            self.lon = lon
            weatherResponse = try await weatherRequestModel.requestToServer(lat: lat, lon: lon)
        } catch {
            print(error)
        }
    }
    
    func coordinatesToCityRequest(_ lat: String, _ lon: String) async throws {
        do {
            try await weatherRequestModel.test()
            cityResponse = try await cityRequestModel.coordinatesToCity(lat: lat, lon: lon)
        } catch {
            print(error)
        }
    }
    
    func cityToCoordinatesRequest(with city: String) async throws -> [String] {
        do {
            cityResponse = try await cityRequestModel.cityToCoordinates(city: city)
            return cityResponse!.geonames.first!.takeCoordinates()
        } catch {
            throw error
        }
    }
    
    private func updateCityBody() async {
        let coordites = weatherResponse!.takeCoordinates()
        
        do {
            try await coordinatesToCityRequest(coordites[0], coordites[1])
        } catch {
            print(error)
        }
    }
    
    func takeCityСonn() async throws -> String{
        guard let weather = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        if let city = cityResponse {
            //исправить
            if city.geonames.first!.takeCoordinates() == weather.takeCoordinates() {
                return city.geonames.first!.takeCity()
            }
        }
        await updateCityBody()
        return cityResponse!.geonames.first!.takeCity()
    }
    
    func takeCountryConn() async throws -> String{
        guard let weather = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        if let city = cityResponse {
            //исправить
            if city.geonames.first!.takeCoordinates() == weather.takeCoordinates() {
                return city.geonames.first!.takeCountry()
            }
        }
        await updateCityBody()
        return cityResponse!.geonames.first!.takeCountry()
    }
    
    func takeCity() -> String {
        guard let city = cityResponse, let firstCity = city.geonames.first else {
            return ""
        }
        return firstCity.takeCity()
    }
    
    func takeCountry() -> String {
        guard let city = cityResponse, let firstCity = city.geonames.first else {
            return ""
        }
        return firstCity.takeCountry()
    }
    
    func takeCoordinates() throws -> [String] {
        guard let latTemp = lat, let lonTemp = lon else {
            throw LocationError.notInitializedCoordinates
        }
        return [latTemp, lonTemp]
    }
}
