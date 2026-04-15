import Foundation

final class WeatherService {
    private let secretKey: String = Secrets().getKey()

    private func createURL(latitude: String, longitude: String) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weather.yandex.ru"
        components.path = "/v2/forecast"
        components.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude)
        ]

        guard let url = components.url else {
            throw NetworkErrors.invalidURL
        }

        return url
    }

    private func requestToServer(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(secretKey, forHTTPHeaderField: "X-Yandex-Weather-Key")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 400..<500:
            throw NetworkErrors.clientError(httpResponse.statusCode)
        case 500..<600:
            throw NetworkErrors.serverError(httpResponse.statusCode)
        default:
            throw NetworkErrors.unexpectedStatusCode(httpResponse.statusCode)
        }
    }

    func fetchWeather(lat: String, lon: String) async throws -> WeatherResponse {
        do {
            let url = try createURL(latitude: lat, longitude: lon)
            let data = try await requestToServer(url: url)
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkErrors.decodingError(decodingError.localizedDescription)
        } catch let networkError as NetworkErrors {
            throw networkError
        } catch {
            throw NetworkErrors.networkError(error.localizedDescription)
        }
    }
}
