//
//  ProfileView.swift
//  StudentAssistents
//
//  Created by Jorgen Boring on 26/10/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    @StateObject var profileVM: ProfileViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        _profileVM = StateObject(wrappedValue: ProfileViewModel(viewModel: viewModel))
    }
    
    var body: some View {
        ZStack {
            Color("DarkBlue")
                .ignoresSafeArea()
            if let username = profileVM.getUsername() {
                Text(username)
            } else {
                Text("Загрузка...")
            }
        }
    }
}
