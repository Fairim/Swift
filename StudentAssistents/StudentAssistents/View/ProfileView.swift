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
            let username : String = profileVM.getUsername()
            let fullName : String = profileVM.getFullName()
            let gender : String = profileVM.getGender()
            let groupName : String = profileVM.getGroupName()
            let instituteName : String = profileVM.getInstituteName()
            let specialization : String = profileVM.getSpecialization()
            
            if profileVM.checkLoadUserData(){
                VStack(alignment: .leading) {
                    HStack{
                        Image("DefaultProfilePhoto")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.25)
                        VStack{
                            Text(fullName)
                                .bold()
                            Text("Mail: \(username)@kpfu.ru")
                                .bold()
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                
                //Тут будет красивый эффект загрузки
                Text("Загрузка...")
            }
        }
    }
}


#Preview {
    ProfileView(viewModel: AuthViewModel())
}
