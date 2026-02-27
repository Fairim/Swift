import Foundation

class CityRequestModel{
    func coordinatesToCity(lat: String, lon: String) async throws -> CityResponse {
        do {
            let url = try createURL(lat, lon, city: "")
            let data = try await requestToServer(url: url)
            let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
            return cityResponse
        } catch let decodingError as DecodingError {
            throw NetworkErrors.decodingError(decodingError.localizedDescription)
        } catch let networkError as NetworkErrors {
            throw networkError
        } catch {
            throw NetworkErrors.networkError(error.localizedDescription)
        }
    }
    
    func cityToCoordinates(city: String) async throws -> CityResponse {
        do {
            let url = try createURL(city: city)
            let data = try await requestToServer(url: url)
            let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
            print(cityResponse)
            return cityResponse
        } catch let decodingError as DecodingError {
            throw NetworkErrors.decodingError(decodingError.localizedDescription)
        } catch let networkError as NetworkErrors {
            throw networkError
        } catch {
            throw NetworkErrors.networkError(error.localizedDescription)
        }
    }
    
    private func createURL(_ lat: String = "", _ lon: String = "", city: String = "") throws -> URL{
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.geonames.org"
        if city.isEmpty {
            components.path = "/findNearbyPlaceNameJSON"
            components.queryItems = [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lng", value: lon),
                URLQueryItem(name: "username", value: "fairim"),
            ]
        }else {
            components.path = "/searchJSON"
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "maxRows", value: "1"),
                URLQueryItem(name: "username", value: "fairim"),
            ]
        }
        guard let url = components.url else {
            throw NetworkErrors.invalidURL
        }
        return url
    }
    
    private func requestToServer(url: URL) async throws -> Data {
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
