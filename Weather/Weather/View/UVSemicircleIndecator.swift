//
//  UVSemicircleIndecator.swift
//  Weather
//
//  Created by Руслан Ахметсафин on 11.04.2026.
//

import SwiftUI

struct UVSemicircleIndecator: View {
    let uvIndex: Double
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    private var progress: Double{
        min(max(uvIndex / 11.0, 0.0), 1.0)
    }
    
    private var gradientColors: [Color] {
        switch uvIndex{
        case 0...2:
            return [.cyan, .green]
        case 3...4:
            return [.yellow, .cyan]
        case 5...6:
            return [.orange, .yellow]
        case 7...8:
            return [.red, .yellow]
        case 9...10:
            return [.purple, .red]
        default:
            return [.black.opacity(0.8), .purple]
        }
    }
    
    var body: some View {
        ZStack {
            //Фоновый полукруглая арка
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.gray.opacity(0.3))
                .rotationEffect(.degrees(180))
                .frame(width: screenWidth / 3, height: screenHeight / 6)
            
            //Заполняем
            Circle()
                .trim(from: 0.0, to: CGFloat(progress * 0.5))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(180))
                .frame(width: screenWidth / 3, height: screenHeight / 6)
        }
    }
}

