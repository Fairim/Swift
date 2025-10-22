import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var login = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            HeaderView()
            LoginPasswordFields(login: $login, password: $password)
            Button(action:
            {
                //Будет запускаться анимация лучей и попытка зайти в аккаунт через async
            }, label: {
                Text("Войти")
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: UIScreen.main.bounds.width / 14)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("DarkBlue")))
                    .foregroundStyle(.white)
                    
            })
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

//Отображение полей логин, пароль
struct LoginPasswordFields : View {
    @Binding var login: String
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        TextField("Логин без @kpfu", text: $login)
            .textFieldStyle(.roundedBorder)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("DarkBlue"), lineWidth: 2)
            )
        HStack{
            Group {
                if isPasswordVisible {
                    TextField("Пароль", text: $password)
                } else {
                    SecureField("Пароль", text: $password)
                }
            }
            .textFieldStyle(.roundedBorder)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("DarkBlue"), lineWidth: 2)
            )
            Button(action: {isPasswordVisible.toggle()}) {
                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                    .foregroundColor(.black)
            }
        }
    }
}

//Необходимо для отображения в нашего кода непосредственно в визуализации
#Preview {
    LoginView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
