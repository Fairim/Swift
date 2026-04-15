import Foundation

struct WeatherSnapshot{
    let city: String
    
    let currentTemperature: Int
    let currentFeelsLike: Int
    let currentCondition: String
    
    let averageFeelsLike: Double
    let minTemperature: Int
    let maxTemperature: Int
    
    let maxWindSpeed: Double
    let averageHumidity: Double
    
    let maxPrecipitationProbability: Int
    
    let hasRain: Bool
    let hasSnow: Bool
    let largeTemperatureDrop: Bool
    
    let uvIndex: Double
}
