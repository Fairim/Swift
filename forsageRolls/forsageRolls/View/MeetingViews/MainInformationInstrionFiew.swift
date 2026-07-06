//
//  MainInformationInstrionFiew.swift
//  forsageRolls
//
//  Created by Руслан Ахметсафин on 06.07.2026.
//

import SwiftUI

struct MainInformationInstrionView: View {
    private let instruction = InstructionsForFirstVisit.self
    
    @Binding var currentIndex: Int
    
    var body: some View {
        Spacer()
        Image(instruction.allCases[currentIndex].getImage())
            .resizable()
            .frame(height: 300)
        Spacer()
        
        VStack(spacing: 14){
            Text(instruction.allCases[currentIndex].getMainInfo())
                .foregroundStyle(LinearGradient.gradientOrange)
                .font(.system(size: 26, weight: .bold))
            Text(instruction.allCases[currentIndex].getSubInfo())
                .foregroundStyle(LinearGradient.gradientOrange)
                .font(.system(size: 21, weight: .medium))
        }
        .padding(.vertical, 40)
    }
}
