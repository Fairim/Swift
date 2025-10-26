import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            ScheduleView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Расписание")
                }
                .tag(0)
            
            ProfileView(viewModel: viewModel)
                .tabItem{
                    Image(systemName: "person")
                    Text("Профиль")
                }
                .tag(1)
        }
    }
}

#Preview {
    MainView(viewModel: AuthViewModel())
}
