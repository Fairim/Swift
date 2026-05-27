import Foundation
import CoreLocation

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
    
    func weatherRequest(persistSnapshot: Bool = false) async throws {
        let locationData = try await locationModel.getCurrentLocation()
        lat = String(locationData.coordinate.latitude)
        lon = String(locationData.coordinate.longitude)
        weatherResponse = try await weatherService.fetchWeather(lat: lat!, lon: lon!)
        currentCity = await bestEffortResolvedCity(lat: lat!, lon: lon!, fallbackCity: nil)
        if persistSnapshot {
            try saveCurrentCitySnapshot()
        }
    }
    
    func weatherRequest(_ lat: String, _ lon: String, fallbackCity: String? = nil, persistSnapshot: Bool = false) async throws {
        self.lat = lat
        self.lon = lon
        weatherResponse = try await weatherService.fetchWeather(lat: lat, lon: lon)
        currentCity = await bestEffortResolvedCity(lat: lat, lon: lon, fallbackCity: fallbackCity ?? currentCity)
        if persistSnapshot {
            try saveCurrentCitySnapshot()
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
        currentCity = city

        do {
            let geo = try await geoCoderService.geocode(city: city)
            lat = String(geo.lat)
            lon = String(geo.lon)
            return [geo.lat, geo.lon]
        } catch {
            if let fallbackCoordinates = await geocodeCityWithApple(city) {
                lat = String(fallbackCoordinates.lat)
                lon = String(fallbackCoordinates.lon)
                return [fallbackCoordinates.lat, fallbackCoordinates.lon]
            }

            throw error
        }
    }
    
    func takeCity() -> String {
        guard let city = currentCity else {
            return ""
        }
        return city
    }

    private func bestEffortResolvedCity(lat: String, lon: String, fallbackCity: String?) async -> String? {
        do {
            if let resolvedCity = try await geoCoderService.reverseGeocode(lat: lat, lon: lon), !resolvedCity.isEmpty {
                return resolvedCity
            }
        } catch {}

        if let localizedCity = await reverseGeocodeWithApple(lat: lat, lon: lon) {
            return localizedCity
        }

        return fallbackCity
    }

    private func reverseGeocodeWithApple(lat: String, lon: String) async -> String? {
        guard let latitude = Double(lat), let longitude = Double(lon) else {
            return nil
        }

        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        do {
            let placemarks: [CLPlacemark] = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLPlacemark], Error>) in
                geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU")) { placemarks, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: placemarks ?? [])
                    }
                }
            }

            guard let placemark = placemarks.first else {
                return nil
            }

            let city = placemark.locality?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if let city, !city.isEmpty {
                return city
            }

            let administrativeArea = placemark.administrativeArea?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if let administrativeArea, !administrativeArea.isEmpty {
                return administrativeArea
            }

            let subAdministrativeArea = placemark.subAdministrativeArea?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if let subAdministrativeArea, !subAdministrativeArea.isEmpty {
                return subAdministrativeArea
            }
        } catch {}

        return nil
    }

    private func geocodeCityWithApple(_ city: String) async -> (lat: Double, lon: Double)? {
        let geocoder = CLGeocoder()

        do {
            let placemarks: [CLPlacemark] = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLPlacemark], Error>) in
                geocoder.geocodeAddressString(city, in: nil, preferredLocale: Locale(identifier: "ru_RU")) { placemarks, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: placemarks ?? [])
                    }
                }
            }

            guard
                let coordinate = placemarks.first?.location?.coordinate
            else {
                return nil
            }

            return (coordinate.latitude, coordinate.longitude)
        } catch {
            return nil
        }
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
            cityName: currentWeather.city.isEmpty ? "Неизвестный город" : currentWeather.city,
            lat: latValue,
            lon: lonValue,
            currentTemperature: currentWeather.temperature,
            currentIcon: currentWeather.icon
        )
    }
}
