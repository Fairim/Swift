//
//  WideSelectionView.swift
//  forsageRolls
//
//  Created by Руслан Ахметсафин on 01.07.2026.
//

import SwiftUI

struct WideSelectionView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            Spacer()
            Image("wideSelection")
                .resizable()
                .frame(height: 300)
            Spacer()
            
            VStack(spacing: 14){
                Text("Широкий выбор")
                    .foregroundStyle(LinearGradient.gradientOrange)
                    .font(.system(size: 26, weight: .bold))
                Text("Более 100 позиций.")
                    .foregroundStyle(LinearGradient.gradientOrange)
                    .font(.system(size: 21, weight: .medium))
            }
            .padding(.vertical, 40)
            CustomPageIndicator(currentPage: $currentIndex)
            
            VStack(spacing: 10) {
                Button(action: {
                    
                }) {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient.gradientOrange)
                            .frame(width: 350, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Text("Далее")
                            .foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .shadow(
                    color: Color.black.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: 8
                )
                
                
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(.clear))
                            .frame(width: 350, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Text("Пропустить")
                            .foregroundColor(Color.gray.opacity(0.8))
                            .font(.system(size: 18, weight: .medium))
                    }
                })
            }
            .padding(.vertical, 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WideSelectionView()
}
