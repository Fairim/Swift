import SwiftUI
@preconcurrency import AppAuth

enum AuthError: Error, LocalizedError{
    case invalidConfiguration
    case noRootViewController
    case authFailed(String)
    case notAuthenticated
    case noAccessToken
    
    var errorDescription: String? {
        switch self{
        case .invalidConfiguration:
            return "Invalid OAuth configuration"
        case .noRootViewController:
            return "Cannot find root view controller"
        case .authFailed(let message):
            return "Authentication failed: \(message)"
        case .notAuthenticated:
            return "You're don't authenticated!"
        case .noAccessToken:
            return "No access token"
        }
    }
}

class AuthManager: NSObject, ObservableObject {
    static let shared = AuthManager()
    private let SM = SecretManager()
    
    @Published var isAuthenticated = false
    @Published var userAccessToken: String?
    @Published var isLoading = false
    @Published var error: String?
    
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    private let baseURL = "https://auth.kpfu.tyuop.ru"
    private lazy var clientID: String = SM.getClientID()
    private lazy var clientSecret: String = SM.getClientSecret()
    private let redirectURL = "com.fairim.StudentAssistents://callback"
    private var authorizationEndpoint: String {return "\(baseURL)/oauth2/authorize"}
    private var tokenEndpoint: String { return "\(baseURL)/api/oauth/token" }
    
    private override init(){
        super.init()
    }
    
    func setAuthState(_ authState: Bool){
        isAuthenticated = authState
    }
    
    func startAuth() async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        guard let redirectURL = URL(string: redirectURL),
              let authEndpoint = URL(string: authorizationEndpoint) else {
            throw AuthError.invalidConfiguration
        }
    
        let authURLString = "\(authEndpoint.absoluteString)?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectURL)&scope=read%20performance%20schedule"
        
        guard let authURL = URL(string: authURLString) else {
            throw AuthError.invalidConfiguration
        }
        
        await MainActor.run {
            // Открываем Safari для аутентификации
            UIApplication.shared.open(authURL)
        }
    }

    func handleCallback(url: URL) -> Bool {
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            return false
        }
        
        exchangeCodeForTokenManually(authorizationCode: code)
        return true
    }

    private func exchangeCodeForTokenManually(authorizationCode: String) {
        guard let tokenEndpoint = URL(string: tokenEndpoint) else {
            self.error = "Invalid token endpoint"
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "grant_type": "authorization_code",
            "code": authorizationCode,
            "redirect_uri": redirectURL,
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        let bodyString = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.error = "No data received from token endpoint"
                    self.isLoading = false
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    if let accessToken = json["access_token"] as? String {
                        DispatchQueue.main.async {
                            self.userAccessToken = accessToken
                            self.isAuthenticated = true
                            self.isLoading = false
                        }
                    } else if let errorMsg = json["error"] as? String {
                        DispatchQueue.main.async {
                            self.error = "OAuth error: \(errorMsg)"
                            self.isLoading = false
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to parse token response"
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
    
    private func handleAuthorizationResponse(authState: OIDAuthState) {
        saveAuthState(authState)
        if let idToken = authState.lastTokenResponse?.idToken,
           let _ = OIDIDToken(idTokenString: idToken) {
            Task { @MainActor in
                self.isAuthenticated = true
                self.isLoading = false
            }
        } else {
            Task { @MainActor in
                self.isAuthenticated = true
                self.isLoading = false
            }
        }
    }
    
    private func saveAuthState(_ authState: OIDAuthState) {
        if let authStateData = try? NSKeyedArchiver.archivedData (
            withRootObject: authState,
            requiringSecureCoding: true
        ) {
            UserDefaults.standard.set(authStateData, forKey: "authState")
        }
    }
    
    private func restoreAuthState() -> OIDAuthState? {
        guard let authStateData = UserDefaults.standard.data(forKey: "authState"),
              let authState = try? NSKeyedUnarchiver.unarchivedObject(
                    ofClass: OIDAuthState.self,
                    from: authStateData
                ) else {
            return nil
        }
        return authState
    }
    
//    func Функция для обработки данных профиля человека
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authState")
        UserDefaults.standard.removeObject(forKey: "userDomain")
        currentAuthorizationFlow?.cancel()
        
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.error = nil
        }
    }
    
}
