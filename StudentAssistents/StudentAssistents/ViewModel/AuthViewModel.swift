import SwiftUI
import AppAuth

class AuthViewModel: ObservableObject {
    private let authManager: AuthManager
    
    @Published var isAuthenticated = false
    @Published var userAccessToken: String?
    @Published var isLoading = false
    @Published var errorMassage: String?
    
    
    init(authManager: AuthManager = AuthManager.shared){
        self.authManager = authManager
        setupBindings()
    }
    
    //Функция которая привязывает model переменные с ViewModel переменными
    private func setupBindings(){
        authManager.$isAuthenticated.assign(to: &$isAuthenticated)
        authManager.$isLoading.assign(to: &$isLoading)
        authManager.$userAccessToken.assign(to: &$userAccessToken)
        
        authManager.$error
            .map{ $0 ?? "" }
            .assign(to: &$errorMassage)
    }
    
    func getAccessToken() -> String{
        return userAccessToken ?? "Nope"
    }
    
    //Ассинхронная работа функции
    func login() async {
        do {
            try await authManager.startAuth()
        } catch {
            errorMassage = error.localizedDescription
        }
    }
    
    func logout() {
        authManager.logout()
    }
    
}
