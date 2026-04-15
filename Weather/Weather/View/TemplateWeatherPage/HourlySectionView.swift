import SwiftUI

struct HourlySectionView: View{
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    var masHourlyWeather: [HourlyWeather] = []
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .padding(3)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                .opacity(0.2)
                .frame(width: screenWidth - 20, height: screenHeight / 7.9, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(Array(masHourlyWeather.enumerated()), id: \.offset) { _, hourInfo in
                        VStack {
                            Text(hourInfo.time)
                                .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                            Image(systemName: hourInfo.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .top)
                                .foregroundColor(.white)
                                .padding(2)
                            Text("\(hourInfo.temperature)°")
                                .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                        }
                        .frame(minWidth: screenWidth / 7, maxWidth: screenWidth / 5, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: screenHeight / 8)
    }
}


#Preview {
    HourlySectionView()
}
