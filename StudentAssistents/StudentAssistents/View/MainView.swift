import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "OffWhite")
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
        }.accentColor(Color("DarkBlue"))
    }
}

#Preview {
    MainView(viewModel: AuthViewModel())
}
