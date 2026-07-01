//
//  CustomPageIndicator.swift
//  forsageRolls
//
//  Created by Руслан Ахметсафин on 01.07.2026.
//

import SwiftUI

struct CustomPageIndicator: View {
    @Binding var currentPage: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .fill(Color(hex: "#FF7666").opacity(currentPage == index ? 1.0 : 0.3))
                    .frame(width: currentPage == index ? 35 : 10, height: 10)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}
