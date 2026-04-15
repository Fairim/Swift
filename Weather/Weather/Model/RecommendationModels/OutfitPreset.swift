import Foundation

struct OutfitPreset {
    let id: String
    let characterType: CharacterType
    let category: WeatherCategory
    let tags: Set<WeatherTag>
    let title: String
    let assetName: String
}

func takePresets() -> [OutfitPreset] {
    return [
        OutfitPreset(
            id: "woman_hot_01",
            characterType: .woman,
            category: .hot,
            tags: [.sunny],
            title: "Лёгкий летний образ",
            assetName: "woman_hot_01"
        ),
        OutfitPreset(
            id: "woman_cold_rain_01",
            characterType: .woman,
            category: .cold,
            tags: [.rain],
            title: "Тёплый дождливый образ",
            assetName: "woman_cold_rain_01"
        ),
        OutfitPreset(
            id: "woman_cold_01",
            characterType: .woman,
            category: .cold,
            tags: [],
            title: "Базовый холодный образ",
            assetName: "woman_cold_01"
        )
    ]
}
