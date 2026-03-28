import Foundation

class WeatherRequestModel {
    
    private func createURL(latitude: String, longitude: String) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: latitude),
            URLQueryItem(name: "longitude", value: longitude),
            URLQueryItem(name: "hourly", value: """
            temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,precipitation_probability,rain,showers,snowfall,wind_speed_10m,wind_direction_10m,wind_gusts_10m,cloud_cover,weather_code,is_day
            """),
            
            URLQueryItem(name: "current_weather", value: "true"),
            
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "7")
            
            
        ]
        
        guard let url = components.url else {
            throw NetworkErrors.invalidURL
        }
        
        return url
    }
    
    func test() async throws{
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.openweathermap.org"
        component.path = "/data/3.0/onecall"
        component.queryItems = [
            URLQueryItem(name: "lat", value: "121"),
            URLQueryItem(name: "lon", value: "123"),
            URLQueryItem(name: "exclude", value: """
                hourly,daily
            """),
            
            URLQueryItem(name: "appid", value: "90769f062facfa76c0553e4575333445"),
        ]
        print(try await requestToServer(url: component.url!))
    }
    
    func requestToServer(lat: String, lon: String) async throws -> WeatherResponse {
        do {
            let url = try createURL(latitude: lat, longitude: lon)
            let data = try await requestToServer(url: url)
            
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch let decodingError as DecodingError {
            throw NetworkErrors.decodingError(decodingError.localizedDescription)
        } catch let networkError as NetworkErrors {
            throw networkError
        } catch {
            throw NetworkErrors.networkError(error.localizedDescription)
        }
    }
    
    func requestToServer(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            switch httpResponse.statusCode {
            case 400..<500:
                throw NetworkErrors.clientError(httpResponse.statusCode)
            case 500..<600:
                throw NetworkErrors.serverError(httpResponse.statusCode)
            default:
                throw NetworkErrors.unexpectedStatusCode(httpResponse.statusCode)
            }
        }
        
        return data
    }
}
