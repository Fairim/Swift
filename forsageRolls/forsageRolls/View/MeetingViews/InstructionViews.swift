import SwiftUI


struct InstructionViews: View {
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            MainInformationInstrionView(currentIndex: $currentIndex)
            CustomPageIndicator(currentPage: $currentIndex)
            
            VStack(spacing: 10) {
                Button(action: {
                    if currentIndex < 3{
                        currentIndex += 1
                    }
                }) {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient.gradientOrange)
                            .frame(width: 350, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Text( currentIndex < 3 ? "Далее" : "Начать наслаждаться" )
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
                    if currentIndex < 3 {
                        currentIndex = 3
                    } else {
                        //Будет переключение на новую страницу входа или регистрации
                    }
                }, label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(.clear))
                            .frame(width: 350, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Text(currentIndex < 3 ? "Пропустить" : "Вход / Регистрация")
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
    InstructionViews()
}
