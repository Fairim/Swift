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

        let category = makeWeatherCategory(feelsLike: weather.averageFeelsLike)
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
        case ..<0:
            return .freezing
        case 0..<8:
            return .cold
        case 8..<15:
            return .cool
        case 15..<22:
            return .mild
        case 22..<28:
            return .warm
        default:
            return .hot
        }
    }
    
    private func makeWeatherTags(from weather: WeatherSnapshot) -> Set<WeatherTag> {
        var tags: Set<WeatherTag> = []

        if weather.hasRain || weather.maxPrecipitationProbability >= 45 {
            tags.insert(.rain)
        }

        if weather.hasSnow {
            tags.insert(.snow)
        }

        if weather.maxWindSpeed >= 8 {
            tags.insert(.windy)
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
        presets.first {
            $0.characterType == characterType &&
            $0.category == category &&
            $0.tags.isEmpty
        }
    }
}
