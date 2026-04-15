import SwiftUI

struct DailySectionView: View{
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    var masDailyWeather: [DailyWeather] = []
    private let nameDays: [String] = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    var body: some View{
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .padding(3)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                .opacity(0.2)
                .frame(maxWidth: screenWidth - 10, alignment: .top)
            
            VStack(spacing: 6) {
                Text("Прогноз на следующие дни")
                    .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                
                ForEach(Array(displayedDailyWeather.enumerated()), id: \.offset) { index, dayWeather in
                    dailyRowView(for: dayWeather, title: titleForDay(at: index))
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private func dailyRowView(for dayWeather: DailyWeather, title: String) -> some View {
        let dayTemperature = dayWeather.dayTemperature ?? 0
        let nightTemperature = dayWeather.nightTemperature ?? 0
        
        return ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .padding(.horizontal, 3)
                .frame(width: screenWidth - 20, height: screenHeight / 20, alignment: .top)
                .opacity(0.3)
            
            HStack(spacing: 2) {
                Text(title)
                    .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                    .frame(maxWidth: screenWidth / 5, alignment: .leading)
                
                Image(systemName: dayWeather.dayIcon)
                    .foregroundColor(.white)
                    .padding(.horizontal, screenWidth / 20)
                
                Text("\(dayTemperature)°")
                    .font(.system(size: screenWidth / 20, weight: .bold, design: .default))
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(temperatureGradient(minTemp: Double(min(dayTemperature, nightTemperature)), maxTemp: Double(max(dayTemperature, nightTemperature))))
                    .frame(width: screenWidth / 3, height: screenHeight / 80, alignment: .trailing)
                    .padding(.horizontal, 10)
                
                Text("\(nightTemperature)°")
                    .font(.system(size: screenWidth / 20, weight: .bold, design: .default))
                    .frame(maxWidth: screenWidth / 16, alignment: .trailing)
            }
        }
    }
    
    private func titleForDay(at index: Int) -> String {
        guard index < nameDays.count else {
            return "День"
        }
        return nameDays[index]
    }
    
    private var displayedDailyWeather: [DailyWeather] {
        Array(masDailyWeather.prefix(nameDays.count))
    }
    
    private func temperatureGradient(minTemp: Double, maxTemp: Double) -> LinearGradient {
        let colors: [Color]
        let avgTemp = (minTemp + maxTemp) / 2
        
        if avgTemp < 0 {
            colors = [Color.blue, Color.cyan]
        } else if avgTemp < 10 {
            colors = [Color.cyan, Color.green]
        } else if avgTemp < 20 {
            colors = [Color.green, Color.yellow]
        } else if avgTemp < 30 {
            colors = [Color.yellow, Color.orange]
        } else {
            colors = [Color.orange, Color.red]
        }
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview{
    DailySectionView()
}
