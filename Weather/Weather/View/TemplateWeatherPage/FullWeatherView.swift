import SwiftUI
import Foundation

struct FullWeatherView: View {
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    var currentWeather: CurrentWeather = CurrentWeather(city: "", temperature: 0, feelsLike: 0, condition: "", humidity: 0, windSpeed: 0, windDirection: "", pressureMm: 0, icon: "")
    var masHourlyWeather: [HourlyWeather] = []
    var masDailyWeather: [DailyWeather] = []
    
    let ufIndex: Double = 1
    
    var body: some View {
        ZStack {
            Image(backgroundAssetName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                MainPanelView(currentWeather: currentWeather, hourlyWeather: masHourlyWeather)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        HourlySectionView(masHourlyWeather: masHourlyWeather)
                        DailySectionView(masDailyWeather: masDailyWeather)
                        extraInfoSectionView
                    }
                    .padding(.bottom, 16)
                }
                .padding(.bottom, screenHeight / 9)
            }
            .padding(.horizontal, 10)
        }
    }

    private var backgroundAssetName: String {
        backgroundName(for: currentWeather.condition, isDay: isDaytime)
    }

    private var isDaytime: Bool {
        if currentWeather.icon.contains("moon") || currentWeather.icon.contains("stars") {
            return false
        }

        let currentHour = Calendar.current.component(.hour, from: .now)
        return (6..<20).contains(currentHour)
    }

    private func backgroundName(for condition: String, isDay: Bool) -> String {
        let normalizedCondition = condition.lowercased()

        if normalizedCondition.contains("thunder") {
            return isDay ? "strongRainBack" : "strongRainNightBack"
        }

        if normalizedCondition.contains("hail")
            || normalizedCondition.contains("ice")
            || normalizedCondition.contains("sleet") {
            return isDay ? "rainIceBack" : "rainIceNightBack"
        }

        if normalizedCondition.contains("snow") {
            if normalizedCondition.contains("heavy")
                || normalizedCondition.contains("blizzard")
                || normalizedCondition.contains("snowstorm") {
                return isDay ? "strongSnowBack" : "strongSnowNightBack"
            }

            return isDay ? "simpleSnowBack" : "simpleSnowNightBack"
        }

        if normalizedCondition.contains("rain")
            || normalizedCondition.contains("drizzle")
            || normalizedCondition.contains("shower") {
            if normalizedCondition.contains("heavy") {
                return isDay ? "strongRainBack" : "strongRainNightBack"
            }

            return isDay ? "simpleRainBack" : "simpleRainNightBack"
        }

        if normalizedCondition == "clear" || normalizedCondition.contains("sunny") {
            return isDay ? "sunnyBack" : "clearNightBack.png"
        }

        if normalizedCondition.contains("partly")
            || normalizedCondition.contains("cloud")
            || normalizedCondition.contains("overcast") {
            return isDay ? "simpleCloudBack" : "cloudNightBack"
        }

        if normalizedCondition.contains("wind") {
            return isDay ? "simpleCloudBack" : "windNightBack"
        }

        return isDay ? "simpleCloudBack" : "cloudNightBack"
    }
    
    private var extraInfoSectionView: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                    .opacity(0.7)
                
                VStack(alignment: .center) {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.orange)
                            .scaleEffect(1.3)
                        Text("УФ-индекс:")
                    }
                    
                    ZStack {
                        UVSemicircleIndecator(uvIndex: ufIndex, screenWidth: screenWidth, screenHeight: screenHeight)
                        VStack {
                            Text(String(Int(ufIndex)))
                                .font(.system(size: screenWidth / 5, weight: .bold, design: .default))
                            Text("Безопасно")
                        }
                    }
                }
                .padding(.top, 10)
            }
            
            VStack(spacing: 10) {
                metricCard(systemName: "drop.fill", value: "\(currentWeather.humidity)%", tint: .blue)
                metricCard(systemName: "wind", value: "\(Int(currentWeather.windSpeed)) м/с", tint: .gray)
            }
        }
        .frame(width: screenWidth - 20, alignment: .center)
    }
    
    private func metricCard(systemName: String, value: String, tint: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: screenWidth / 2 - 15, height: screenHeight / 10 - 5)
                .opacity(0.7)
            
            HStack {
                Image(systemName: systemName)
                    .foregroundColor(tint)
                Text(value)
                    .font(.system(size: screenWidth / 20, weight: .bold, design: .default))
            }
        }
    }
}

//#Preview {
//    FullWeatherView()
//}
