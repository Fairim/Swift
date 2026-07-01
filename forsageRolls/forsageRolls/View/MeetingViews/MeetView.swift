//
//  ContentView.swift
//  forsageRolls
//
//  Created by Руслан Ахметсафин on 01.07.2026.
//

import SwiftUI

struct MeetView: View {
    @State private var isPressed = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("welcomeBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient (
                            colors: [.clear, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(spacing: 10) {
                    Spacer()
                    Text("Добро пожаловать")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                    Text("ФОРСАЖ ролл")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding()
            }
            .frame(width: .infinity, height: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                isPressed = true
            }
            
            .navigationDestination(isPresented: $isPressed) {
                WideSelectionView()
            }
            
        }
    }
}

#Preview {
    MeetView()
}
