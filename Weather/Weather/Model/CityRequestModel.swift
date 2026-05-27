import Foundation

final class DaDataGeocoder {
    private let token = SecretLocation().getKey()
    private let secret = SecretLocation().getSecret()

    func geocode(city: String) async throws -> (lat: Double, lon: Double) {
        guard let url = URL(string: "https://cleaner.dadata.ru/api/v1/clean/address") else {
            throw LocationError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(secret, forHTTPHeaderField: "X-Secret")

        let body = [city]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LocationError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw LocationError.badStatusCode(httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode([DaDataAddress].self, from: data)

        guard let first = decoded.first else {
            throw LocationError.emptyResult
        }

        guard
            let latString = first.geoLat,
            let lonString = first.geoLon,
            let lat = Double(latString),
            let lon = Double(lonString)
        else {
            throw LocationError.noCoordinates
        }

        return (
            lat: lat,
            lon: lon
        )
    }
    
    func reverseGeocode(lat: String, lon: String) async throws -> String? {
        guard let url = URL(string: "https://cleaner.dadata.ru/api/v1/clean/address") else {
            throw LocationError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(secret, forHTTPHeaderField: "X-Secret")

        let body = ["\(lat),\(lon)"]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw LocationError.invalidResponse
        }

        let decoded = try JSONDecoder().decode([DaDataAddress].self, from: data)

        guard let first = decoded.first else {
            throw LocationError.emptyResult
        }

        return preferredCityName(from: first)
    }

    private func preferredCityName(from address: DaDataAddress) -> String? {
        if let city = normalized(address.city) {
            return city
        }
        if let settlement = normalized(address.settlement) {
            return settlement
        }
        if let result = normalized(address.result) {
            return result
                .components(separatedBy: ",")
                .first?
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }

    private func normalized(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
