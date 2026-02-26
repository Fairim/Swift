import Foundation

class NetworkRequest {
    
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
        print("Сделали ссылку")
        
        guard let url = components.url else {
            throw NetworkErrors.invalidURL
        }
        
        print(url)
        return url
    }
    
    func requestToServer(lat: String, lon: String) async throws -> WeatherResponse {
        do {
            let url = try createURL(latitude: lat, longitude: lon)
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
            
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            print("Сделали запрос")
            return weatherResponse
            
        } catch let decodingError as DecodingError {
            throw NetworkErrors.decodingError(decodingError.localizedDescription)
        } catch let networkError as NetworkErrors {
            throw networkError
        } catch {
            throw NetworkErrors.networkError(error.localizedDescription)
        }
    }
}
