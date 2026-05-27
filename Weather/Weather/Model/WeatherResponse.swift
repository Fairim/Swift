import Foundation

struct WeatherResponse: Decodable {
    let now: Int
    let nowDt: String
    let info: WeatherInfo
    let fact: Fact
    let forecasts: [Forecast]

    enum CodingKeys: String, CodingKey {
        case now
        case nowDt = "now_dt"
        case info
        case fact
        case forecasts
    }
}

struct WeatherInfo: Decodable {
    let tzinfo: TimeZoneInfo
}

struct TimeZoneInfo: Decodable {
    let name: String
}

struct Fact: Decodable {
    let temp: Int
    let feelsLike: Int
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let windDir: String
    let pressureMm: Int
    let icon: String

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case condition
        case humidity
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case icon
    }
}

struct Forecast: Decodable {
    let date: String
    let hours: [Hour]
    let parts: Parts
}

struct Hour: Decodable {
    let hour: String
    let hourTs: Int
    let temp: Int
    let feelsLike: Int
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let windDir: String
    let pressureMm: Int
    let icon: String
    let precProb: Int

    enum CodingKeys: String, CodingKey {
        case hour
        case hourTs = "hour_ts"
        case temp
        case feelsLike = "feels_like"
        case condition
        case humidity
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case icon
        case precProb = "prec_prob"
    }
}

struct Parts: Decodable {
    let dayShort: DayPart
    let nightShort: DayPart

    enum CodingKeys: String, CodingKey {
        case dayShort = "day_short"
        case nightShort = "night_short"
    }
}

struct DayPart: Decodable {
    let temp: Int?
    let tempMin: Int?
    let tempMax: Int?
    let feelsLike: Int
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let windDir: String
    let pressureMm: Int
    let icon: String
    let precProb: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
        case condition
        case humidity
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case icon
        case precProb = "prec_prob"
    }
}

extension WeatherResponse {
    func currentWeather(city: String?) -> CurrentWeather {
        let resolvedCity: String
        if let city, !city.isEmpty {
            resolvedCity = city
        } else {
            resolvedCity = cityFromResponse()
        }
        
        return CurrentWeather(
            city: resolvedCity,
            temperature: fact.temp,
            feelsLike: fact.feelsLike,
            condition: fact.condition,
            humidity: fact.humidity,
            windSpeed: fact.windSpeed,
            windDirection: fact.windDir,
            pressureMm: fact.pressureMm,
            icon: mapWeatherIcon(fact.icon)
        )
    }
    
    private func cityFromResponse() -> String {
        let timeZoneName = info.tzinfo.name
        let rawCity = timeZoneName
            .split(separator: "/")
            .last
            .map(String.init) ?? ""
        
        return rawCity.replacingOccurrences(of: "_", with: " ")
    }
    
    private func mapWeatherIcon(_ code: String) -> String {
        switch code {
        case "skc_d":
            return "sun.max.fill"
        case "skc_n":
            return "moon.stars.fill"
        case "bkn_d":
            return "cloud.sun.fill"
        case "bkn_n":
            return "cloud.moon.fill"
        case "ovc":
            return "cloud.fill"
        case "ovc_-ra", "ovc_ra":
            return "cloud.rain.fill"
        case "ovc_+ra":
            return "cloud.heavyrain.fill"
        case "ovc_-sn", "ovc_sn", "ovc_+sn":
            return "cloud.snow.fill"
        case "ovc_-ts-ra", "ovc_ts_ra", "ovc_ts_sn":
            return "cloud.bolt.rain.fill"
        default:
            if code.contains("ra") {
                return "cloud.rain.fill"
            }
            if code.contains("sn") {
                return "cloud.snow.fill"
            }
            if code.contains("ts") {
                return "cloud.bolt.fill"
            }
            if code.contains("bkn") {
                return "cloud.sun.fill"
            }
            if code.contains("ovc") {
                return "cloud.fill"
            }
            return "cloud.fill"
        }
    }
}

extension WeatherResponse {
    func hourlyWeather24h() -> [HourlyWeather] {
        let allHours = forecasts
            .flatMap(\.hours)
            .sorted { $0.hourTs < $1.hourTs }
        
        let startOfCurrentHour = currentHourStartTimestamp()
        let upcomingHours = allHours
            .filter { $0.hourTs >= startOfCurrentHour }
            .prefix(24)
        
        return Array(upcomingHours.enumerated()).map { index, hour in
            HourlyWeather(
                time: index == 0 ? "Сейчас" : formattedHour(for: hour.hourTs),
                timestamp: hour.hourTs,
                temperature: hour.temp,
                feelsLike: hour.feelsLike,
                condition: hour.condition,
                humidity: hour.humidity,
                windSpeed: hour.windSpeed,
                windDirection: hour.windDir,
                pressureMm: hour.pressureMm,
                precipitationProbability: hour.precProb,
                icon: mapWeatherIcon(hour.icon)
            )
        }
    }
}

extension WeatherResponse {
    func weeklyWeather() -> [DailyWeather] {
        forecasts.map {
            DailyWeather(
                title: dayTitle(for: $0.date),
                date: $0.date,
                dayTemperature: $0.parts.dayShort.temp,
                nightTemperature: $0.parts.nightShort.temp,
                dayCondition: $0.parts.dayShort.condition,
                nightCondition: $0.parts.nightShort.condition,
                dayWindSpeed: $0.parts.dayShort.windSpeed,
                nightWindSpeed: $0.parts.nightShort.windSpeed,
                dayIcon: mapWeatherIcon($0.parts.dayShort.icon),
                nightIcon: mapWeatherIcon($0.parts.nightShort.icon)
            )
        }
    }
}

private extension WeatherResponse {
    func weatherTimeZone() -> TimeZone {
        TimeZone(identifier: info.tzinfo.name) ?? .current
    }
    
    func currentHourStartTimestamp() -> Int {
        let timeZone = weatherTimeZone()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        
        let nowDate = Date(timeIntervalSince1970: TimeInterval(now))
        let startOfHour = calendar.dateInterval(of: .hour, for: nowDate)?.start ?? nowDate
        return Int(startOfHour.timeIntervalSince1970)
    }
    
    func formattedHour(for timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = weatherTimeZone()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func dayTitle(for dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = weatherTimeZone()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let forecastDate = formatter.date(from: dateString) else {
            return "День"
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = weatherTimeZone()
        
        let currentDate = Date(timeIntervalSince1970: TimeInterval(now))
        if calendar.isDate(forecastDate, inSameDayAs: currentDate) {
            return "Сегодня"
        }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ru_RU")
        weekdayFormatter.timeZone = weatherTimeZone()
        weekdayFormatter.dateFormat = "EE"
        
        let weekday = weekdayFormatter.string(from: forecastDate)
            .replacingOccurrences(of: ".", with: "")
        return weekday.prefix(1).uppercased() + weekday.dropFirst()
    }
}
