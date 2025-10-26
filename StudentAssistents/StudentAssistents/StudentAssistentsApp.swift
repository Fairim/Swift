//
//  StudentAssistentsApp.swift
//  StudentAssistents
//
//  Created by Руслан Ахметсафин on 21.10.2025.
//

import SwiftUI

@main
struct StudentAssistentsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                NavigationStack {
                    MainView(viewModel: viewModel)
                }
            } else {
                LoginView(viewModel: viewModel)
                    .environmentObject(AuthManager.shared)
                    .onOpenURL { url in
                        _ = AuthManager.shared.handleCallback(url: url)
                    }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool{
        if url.scheme == "com.fairim.StudentAssistents" {
            return AuthManager.shared.handleCallback(url: url)
        }
        return false
    }
}
