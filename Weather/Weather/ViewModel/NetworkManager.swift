import Foundation

class NetworkManager {
    static let shared = NetworkManager(); private init() {}
    private let locationModel = LocationModel()
    private var weatherResponse: WeatherResponse?
    private let weatherService = WeatherService()
    private let geoCoderService = DaDataGeocoder()
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
        } catch {
            print(error)
        }
    }
    
    func weatherRequest(_ lat: String, _ lon: String) async throws {
        do {
            self.lat = lat
            self.lon = lon
            weatherResponse = try await weatherService.fetchWeather(lat: lat, lon: lon)
        } catch {
            print(error)
        }
    }
    
    
    func fetchCurrentWeather() async throws -> CurrentWeather {
        guard let response = weatherResponse else {
            throw NetworkErrors.notInitializedWeather
        }
        return response.currentWeather()
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
            let geo = try await geoCoderService.geocode(city: "Москва")
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
//
//    private func updateCityBody() async {
//        let coordites = weatherResponse!.takeCoordinates()
//        
//        do {
//            try await coordinatesToCityRequest(coordites[0], coordites[1])
//        } catch {
//            print(error)
//        }
//    }
//    
//    func takeCityСonn() async throws -> String{
//        guard let weather = weatherResponse else {
//            throw NetworkErrors.notInitializedWeather
//        }
//        if let city = cityResponse {
//            //исправить
//            if city.geonames.first!.takeCoordinates() == weather.takeCoordinates() {
//                return city.geonames.first!.takeCity()
//            }
//        }
//        await updateCityBody()
//        return cityResponse!.geonames.first!.takeCity()
//    }
//    
//    func takeCountryConn() async throws -> String{
//        guard let weather = weatherResponse else {
//            throw NetworkErrors.notInitializedWeather
//        }
//        if let city = cityResponse {
//            //исправить
//            if city.geonames.first!.takeCoordinates() == weather.takeCoordinates() {
//                return city.geonames.first!.takeCountry()
//            }
//        }
//        await updateCityBody()
//        return cityResponse!.geonames.first!.takeCountry()
//    }
    
//    
//    func takeCountry() -> String {
//        guard let city = cityResponse, let firstCity = city.geonames.first else {
//            return ""
//        }
//        return firstCity.takeCountry()
//    }
//    
//    func takeCoordinates() throws -> [String] {
//        guard let latTemp = lat, let lonTemp = lon else {
//            throw LocationError.notInitializedCoordinates
//        }
//        return [latTemp, lonTemp]
//    }
//    
//    func takeMassTime() -> [String] {
//        guard let time = weatherResponse?.hourlyData.time else {
//            return []
//        }
//        return time
//    }
//    
//    func takeMassTemperature() -> [Double] {
//        guard let temperature = weatherResponse?.hourlyData.temperature else {
//            return []
//        }
//        return temperature.compactMap(Double.init)
//    }
//    
//    func takeApparentTemperature() -> [Double] {
//        guard let apparentTemperature = weatherResponse?.hourlyData.time else {
//            return []
//        }
//        return apparentTemperature.compactMap(Double.init)
//    }
//    
//    func takeRelativeHumidity() -> [Int] {
//        guard let relativeHumidity = weatherResponse?.hourlyData.relativeHumidity else {
//            return []
//        }
//        return relativeHumidity
//    }
//    
//    func takeMassPrecipitation() -> [Double] {
//        guard let precipitation = weatherResponse?.hourlyData.precipitation else {
//            return []
//        }
//        return precipitation
//    }
//    
//    func takeMassPrecipitationProbability() -> [Int] {
//        guard let precipitationProbability = weatherResponse?.hourlyData.precipitationProbability else {
//            return []
//        }
//        return precipitationProbability
//    }
//    
//    func takeMassRain() -> [Double] {
//        guard let rain = weatherResponse?.hourlyData.rain else {
//            return []
//        }
//        return rain
//    }
//    
//    func takeMassShowers() -> [Double] {
//        guard let showers = weatherResponse?.hourlyData.showers else {
//            return []
//        }
//        return showers
//    }
//    
//    func takeMassSnowfall() -> [Double] {
//        guard let snowfall = weatherResponse?.hourlyData.snowfall else {
//            return []
//        }
//        return snowfall
//    }
//    
//    func takeMassWindSpeed() -> [Double] {
//        guard let windSpeed = weatherResponse?.hourlyData.windSpeed else {
//            return []
//        }
//        return windSpeed
//    }
//    
//    func takeMassWindDirection() -> [Int] {
//        guard let windDirection = weatherResponse?.hourlyData.windDirection else {
//            return []
//        }
//        return windDirection
//    }
//    
//    func takeMassWindGusts() -> [Double] {
//        guard let windGusts = weatherResponse?.hourlyData.windGusts else {
//            return []
//        }
//        return windGusts
//    }
//    
//    func takeMassCloudCover() -> [Int] {
//        guard let cloudCover = weatherResponse?.hourlyData.cloudCover else {
//            return []
//        }
//        return cloudCover
//    }
//    
//    func takeMassWeatherCode() -> [Int] {
//        guard let weatherCode = weatherResponse?.hourlyData.weatherCode else {
//            return []
//        }
//        return weatherCode
//    }
//    
//    func takeMassIsDay() -> [Int] {
//        guard let isDay = weatherResponse?.hourlyData.isDay else {
//            return []
//        }
//        return isDay
//    }
}
