struct CurrentWeather {
    let city: String
    let temperature: Int
    let feelsLike: Int
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let windDirection: String
    let pressureMm: Int
    let icon: String
}

struct HourlyWeather {
    let time: String
    let timestamp: Int
    let temperature: Int
    let feelsLike: Int
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let windDirection: String
    let pressureMm: Int
    let precipitationProbability: Int
    let icon: String
}

struct DailyWeather {
    let date: String
    let dayTemperature: Int?
    let nightTemperature: Int?
    let dayCondition: String
    let nightCondition: String
    let dayWindSpeed: Double
    let nightWindSpeed: Double
    let dayIcon: String
    let nightIcon: String
}
