import SwiftUI
import CoreData

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    var body: some View {
        VStack(spacing: 30) {
            HeaderView()
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                Text("Войти через OAuth2")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                    }
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("DarkBlue"), .blue, .white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
    }
}

//Отображение всех текстовых значений
struct HeaderView: View {
    var body: some View {
        Image("Griffin")
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width / 4)
        Text("Student Assistent")
            .font(.title2)
            .bold()
            .italic()
        Text("Твой университет - твой помощник")
            .font(.callout)
            .italic()
            .foregroundStyle(.white.opacity(0.5))
    }
}

//Необходимо для отображения в нашего кода непосредственно в визуализации
#Preview {
    LoginView(viewModel: AuthViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
