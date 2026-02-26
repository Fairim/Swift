import Foundation

struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timeGenerated: Double
    let utcOffset: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    let currentWeatherUtils: CurrentWeatherUnits
    let currentWeather: CurrentWeather
    let hourlyUtils: HourlyDataUnits
    let hourlyData: HourlyData
    
    enum CodingKeys: String, CodingKey {
        case lat = "latitude"
        case lon = "longitude"
        case timeGenerated = "generationtime_ms"
        case utcOffset = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentWeatherUtils = "current_weather_units"
        case currentWeather = "current_weather"
        case hourlyUtils = "hourly_units"
        case hourlyData = "hourly"
    }
}

struct CurrentWeatherUnits: Codable {
    let time: String
    let interval: String
    let temperature: String
    let windSpeed: String
    let windDirection: String
    let isDay: String
    let weatherCode: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case isDay = "is_day"
        case weatherCode = "weathercode"
    }
}

struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Double
    let windSpeed: Double
    let windDirection: Int
    let isDay: Int
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case isDay = "is_day"
        case weatherCode = "weathercode"
    }
}

struct HourlyDataUnits: Codable {
    let time: String
    let temperature: String
    let apparentTemperature: String
    let relativeHumidity: String
    let precipitation: String
    let precipitationProbability: String
    let rain: String
    let showers: String
    let snowfall: String
    let windSpeed: String
    let windDirection: String
    let windGusts: String
    let cloudCover: String
    let weatherCode: String
    let isDay: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity = "relative_humidity_2m"
        case precipitation
        case precipitationProbability = "precipitation_probability"
        case rain
        case showers
        case snowfall
        case windSpeed = "wind_speed_10m"
        case windDirection = "wind_direction_10m"
        case windGusts = "wind_gusts_10m"
        case cloudCover = "cloud_cover"
        case weatherCode = "weather_code"
        case isDay = "is_day"
    }
}

struct HourlyData: Codable {
    let time: [String]
    let temperature: [Double]
    let apparentTemperature: [Double]
    let relativeHumidity: [Int]
    let precipitation: [Double]
    let precipitationProbability: [Int]
    let rain: [Double]
    let showers: [Double]
    let snowfall: [Double]
    let windSpeed: [Double]
    let windDirection: [Int]
    let windGusts: [Double]
    let cloudCover: [Int]
    let weatherCode: [Int]
    let isDay: [Int]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity = "relative_humidity_2m"
        case precipitation
        case precipitationProbability = "precipitation_probability"
        case rain
        case showers
        case snowfall
        case windSpeed = "wind_speed_10m"
        case windDirection = "wind_direction_10m"
        case windGusts = "wind_gusts_10m"
        case cloudCover = "cloud_cover"
        case weatherCode = "weather_code"
        case isDay = "is_day"
    }
}


