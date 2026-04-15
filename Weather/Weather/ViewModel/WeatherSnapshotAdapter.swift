import Foundation

struct WeatherSnapshotAdapter {
    
    func makeInput(
        current: CurrentWeather,
        hourly: [HourlyWeather]
    ) -> WeatherSnapshot {
        
        let feelsLikeValues = hourly.map(\.feelsLike)
        let tempValues = hourly.map(\.temperature)
        let humidityValues = hourly.map(\.humidity)
        let windValues = hourly.map(\.windSpeed)
        let precipitationValues = hourly.map(\.precipitationProbability)
        
        let averageFeelsLike = feelsLikeValues.isEmpty ? Double(current.feelsLike) : Double(feelsLikeValues.reduce(0, +)) / Double(feelsLikeValues.count)
        
        let minTemperature = tempValues.min() ?? current.temperature
        let maxTemperature = tempValues.max() ?? current.temperature
        
        let averageHumidity = humidityValues.isEmpty ? Double(current.humidity) : Double(humidityValues.reduce(0, +)) / Double(humidityValues.count)
        
        let maxWindSpeed = max(windValues.max() ?? current.windSpeed, current.windSpeed)
        let maxPrecipitationProbability = precipitationValues.max() ?? 0
        
        let condition = ([current.condition] + hourly.map(\.condition)).map {
            $0.lowercased()
        }
        
        let hasRain = condition.contains {
            condition in
            condition.contains("rain") || condition.contains("дождь")
        }
        
        let hasSnow = condition.contains {
            condition in
            condition.contains("snow") || condition.contains("снег")
        }
        
        let largeTempertatureDrop = (maxTemperature - minTemperature) >= 8
        
        return WeatherSnapshot(
            city: current.city,
            currentTemperature: current.temperature,
            currentFeelsLike: current.feelsLike,
            currentCondition: current.condition,
            averageFeelsLike: averageFeelsLike,
            minTemperature: minTemperature,
            maxTemperature: maxTemperature,
            maxWindSpeed: maxWindSpeed,
            averageHumidity: averageHumidity,
            maxPrecipitationProbability: maxPrecipitationProbability,
            hasRain: hasRain,
            hasSnow: hasSnow,
            largeTemperatureDrop: largeTempertatureDrop,
            uvIndex: 0)
    }
}
