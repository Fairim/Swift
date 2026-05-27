import Foundation

final class OutfitAdvisorEngine {
    private let presets: [OutfitPreset]
        
    init(presets: [OutfitPreset]) {
        self.presets = presets
    }

    func chooseOutfit(
            characterType: CharacterType,
            weather: WeatherSnapshot
        ) -> OutfitPreset? {

        let category = makeWeatherCategory(feelsLike: recommendationFeelsLike(for: weather))
        let weatherTags = makeWeatherTags(from: weather)

        let candidates = presets.filter {
            $0.characterType == characterType && $0.category == category
        }

        if candidates.isEmpty {
            return fallbackPreset(for: characterType, category: category)
        }

        let sorted = candidates.sorted {
            matchScore(for: $0, weatherTags: weatherTags) >
            matchScore(for: $1, weatherTags: weatherTags)
        }

        return sorted.first ?? fallbackPreset(for: characterType, category: category)
    }
    
    
    func makeWeatherCategory(feelsLike: Double) -> WeatherCategory {
        switch feelsLike {
        case ..<3:
            return .freezing
        case 3..<7:
            return .cold
        case 7..<17:
            return .mild
        case 17..<24:
            return .warm
        default:
            return .hot
        }
    }

    private func recommendationFeelsLike(for weather: WeatherSnapshot) -> Double {
        var effectiveFeelsLike = Double(weather.currentFeelsLike)

        if weather.maxWindSpeed >= 11 {
            effectiveFeelsLike -= 1
        }

        if weather.hasRain && weather.currentFeelsLike <= 12 {
            effectiveFeelsLike -= 1
        }

        if weather.largeTemperatureDrop && weather.currentFeelsLike >= 20 {
            effectiveFeelsLike -= 1
        }

        return effectiveFeelsLike
    }
    
    private func makeWeatherTags(from weather: WeatherSnapshot) -> Set<WeatherTag> {
        var tags: Set<WeatherTag> = []

        if weather.hasRain || weather.maxPrecipitationProbability >= 45 {
            tags.insert(.rain)
        }

        if weather.hasSnow {
            tags.insert(.snow)
        }

        if weather.uvIndex >= 6 {
            tags.insert(.sunny)
        }

        if weather.largeTemperatureDrop {
            tags.insert(.largeDrop)
        }

        return tags
    }
    
    private func matchScore(for preset: OutfitPreset, weatherTags: Set<WeatherTag>) -> Int {
        var score = 0
        for tag in preset.tags {
            if weatherTags.contains(tag) {
                score += 2
            }
        }
        
        if preset.tags.isEmpty {
            score += 1
        }
        
        return score
    }
    
    private func fallbackPreset(for characterType: CharacterType, category: WeatherCategory) -> OutfitPreset? {
        let fallbackOrder = fallbackCategories(for: category)

        for fallbackCategory in fallbackOrder {
            if let preset = presets.first(where: {
                $0.characterType == characterType &&
                $0.category == fallbackCategory &&
                $0.tags.isEmpty
            }) {
                return preset
            }
        }

        return presets.first { $0.characterType == characterType }
    }

    private func fallbackCategories(for category: WeatherCategory) -> [WeatherCategory] {
        switch category {
        case .freezing:
            return [.freezing, .cold, .mild, .warm, .hot]
        case .cold:
            return [.cold, .mild, .freezing, .warm, .hot]
        case .cool:
            return [.mild, .cold, .warm, .freezing, .hot]
        case .mild:
            return [.mild, .warm, .cold, .hot, .freezing]
        case .warm:
            return [.warm, .mild, .hot, .cold, .freezing]
        case .hot:
            return [.hot, .warm, .mild, .cold, .freezing]
        }
    }
}
