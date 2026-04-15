import SwiftUI

struct MainPanelView: View {
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    var currentWeather: CurrentWeather = CurrentWeather(city: "", temperature: 0, feelsLike: 0, condition: "", humidity: 0, windSpeed: 0, windDirection: "", pressureMm: 0, icon: "")
    var hourlyWeather: [HourlyWeather] = []
    //На данный момент, будет стандартно мужщина, после добавим выбор
    let characterChoose: CharacterType = .man
    var body: some View {
        Text(currentWeather.city.isEmpty ? "Город" : currentWeather.city)
            .font(.system(size: 30, weight: .bold, design: .default))
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, screenHeight / 15)
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .padding(3)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                .opacity(0.6)
                .frame(maxWidth: screenWidth - 20, maxHeight: screenHeight / 4, alignment: .top)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(currentWeather.temperature)°")
                        .font(.system(size: 60, weight: .bold, design: .default))
                        .padding(.leading, screenWidth / 12)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(temperatureColor(currTemp: Double(currentWeather.feelsLike))))
                            .padding(3)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                            .opacity(0.3)
                            .frame(minWidth: screenWidth / 2, maxWidth: screenWidth / 1.5, maxHeight: screenHeight / 7, alignment: .leading)
                            .padding(.leading, 20)
                        
                        VStack {
                            HStack {
                                Image(systemName: "thermometer.variable")
                                Text("Ощущается как:")
                            }
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            
                            Text("\(currentWeather.feelsLike)°")
                                .font(.system(size: screenWidth / 10, weight: .bold, design: .default))
                        }
                    }
                }
                .frame(maxWidth: screenWidth / 2.2)
                
                ZStack(alignment: .topTrailing) {
                    Image("human")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth / 2.2, height: screenHeight / 4, alignment: .center)
                    
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private func temperatureColor(currTemp: Double) -> UIColor {
        switch currTemp {
        case (-30)...(-20):
            return UIColor(.blue)
        case (-19)...(-1):
            return UIColor(.cyan)
        case 1...15:
            return UIColor(.yellow)
        case 16...25:
            return UIColor(.orange)
        case 26...50:
            return UIColor(.red)
        default:
            return UIColor(.white)
        }
    }
}

#Preview {
    MainPanelView()
}
