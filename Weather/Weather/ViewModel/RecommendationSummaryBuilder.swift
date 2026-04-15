import Foundation

struct RecommendationSummaryBuilder {
    func buildSummary(
        weather: WeatherSnapshot
    ) -> String {
        let feeling: String
        
        switch weather.currentFeelsLike {
        case ..<0:
            feeling = "Очень холодно"
        case 0..<8:
            feeling = "Холодно"
        case 8..<15:
            feeling = "Прохладно"
        case 15..<22:
            feeling = "Комфортно"
        case 22..<28:
            feeling = "Тепло"
        default:
            feeling = "Жарко"
        }
        
        var reasons: [String] = []
        
        if weather.hasRain { reasons.append("возможен дождь") }
        if weather.hasSnow { reasons.append("возможен снег") }
        if weather.maxWindSpeed >= 8 { reasons.append("ветер усиливает прохладу") }
        if weather.largeTemperatureDrop { reasons.append("к вечеру станет холоднее") }
    
        let extra = reasons.isEmpty ? "." : ", " + reasons.joined(separator: ", ") + "."
        
        return "\(feeling)\(extra)"
    }
}
