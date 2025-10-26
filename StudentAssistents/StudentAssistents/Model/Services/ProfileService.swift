import Foundation

struct APIResponse: Codable {
    let success: Bool
    let user: UserProfile
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingError
    case unauthorized
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid server response"
        case .requestFailed(let statusCode):
            return "Request failed with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized access"
        case .encodingError:
            return "Encoding error"
        }
    }
}

class ProfileService: NSObject, ObservableObject {
    private let baseURL = "https://auth.kpfu.tyuop.ru"
    
    func fetchUserProfile(accessToken: String) async throws -> UserProfile {
        guard let url = URL(string: "\(baseURL)/api/v1/users/@me") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "select": [
                "id": true,
                "username": true,
                "firstName": true,
                "lastName": true,
                "middleName": true,
                "gender": true,
                "photoPath": true,
                "studentId": true,
                "group": [
                    "id": true,
                    "name": true,
                    "instituteName": true,
                    "specialization": true,
                    "speciality": true,
                    "yearStart": true,
                    "yearEnd": true
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw APIError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        
        do {
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.requestFailed(statusCode: httpResponse.statusCode)
            }
            
            let userProfile = UserProfile(
                id: apiResponse.user.id,
                username: apiResponse.user.username,
                firstName: apiResponse.user.firstName,
                lastName: apiResponse.user.lastName,
                middleName: apiResponse.user.middleName,
                gender: apiResponse.user.gender,
                photoPath: apiResponse.user.photoPath,
                studentId: apiResponse.user.studentId,
                group: apiResponse.user.group
            )
            
            
            print("✅ Profile loaded successfully!")
            print("👤 User: \(userProfile.username)")
            print("🎓 Group: \(userProfile.group.name)")
            
            return userProfile
        } catch {
            throw APIError.decodingError
        }
    }
}
