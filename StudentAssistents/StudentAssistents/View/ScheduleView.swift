//
//  ScheduleView.swift
//  StudentAssistents
//
//  Created by Jorgen Boring on 26/10/2025.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: AuthViewModel
    var body: some View {
        ZStack {
            Color("DarkBlue")
                .ignoresSafeArea()
            Text("This page you see schedule!")
        }
    }
}

#Preview {
    ScheduleView(viewModel: AuthViewModel())
}
