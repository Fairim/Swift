import Foundation

struct OutfitPreset {
    let id: String
    let characterType: CharacterType
    let category: WeatherCategory
    let tags: Set<WeatherTag>
    let assetName: String
}

func takePresets() -> [OutfitPreset] {
    return [
        //Образы мужчины
        OutfitPreset(
            id: "man_cold",
            characterType: .man,
            category: .cold,
            tags: [],
            assetName: "man_cold"
        ),
        OutfitPreset(
            id: "man_easily_warm_rain",
            characterType: .man,
            category: .mild,
            tags: [.rain],
            assetName: "man_easily_warm_rain"
        ),
        OutfitPreset(
            id: "man_easily_warm",
            characterType: .man,
            category: .mild,
            tags: [],
            assetName: "man_easily_warm"
        ),
        OutfitPreset(
            id: "man_hot_rain",
            characterType: .man,
            category: .hot,
            tags: [.rain],
            assetName: "man_hot_rain"
        ),
        OutfitPreset(
            id: "man_hot",
            characterType: .man,
            category: .hot,
            tags: [],
            assetName: "man_hot"
        ),
        OutfitPreset(
            id: "man_warm_rain",
            characterType: .man,
            category: .warm,
            tags: [.rain],
            assetName: "man_warm_rain"
        ),
        OutfitPreset(
            id: "man_warm",
            characterType: .man,
            category: .warm,
            tags: [],
            assetName: "man_warm"
        ),
        
        //Образы беременной
        OutfitPreset(
            id: "pregnant_cold",
            characterType: .pregnant,
            category: .cold,
            tags: [],
            assetName: "pregnant_cold"
        ),
        OutfitPreset(
            id: "pregnant_easily_warm_rain",
            characterType: .pregnant,
            category: .mild,
            tags: [.rain],
            assetName: "pregnant_easily_warm_rain"
        ),
        OutfitPreset(
            id: "pregnant_easily_warm",
            characterType: .pregnant,
            category: .mild,
            tags: [],
            assetName: "pregnant_easily_warm"
        ),
        OutfitPreset(
            id: "pregnant_hot_rain",
            characterType: .pregnant,
            category: .hot,
            tags: [.rain],
            assetName: "pregnant_hot_rain"
        ),
        OutfitPreset(
            id: "pregnant_hot",
            characterType: .pregnant,
            category: .hot,
            tags: [],
            assetName: "pregnant_hot"
        ),
        OutfitPreset(
            id: "pregnant_warm_rain",
            characterType: .pregnant,
            category: .warm,
            tags: [.rain],
            assetName: "pregnant_warm_rain"
        ),
        OutfitPreset(
            id: "pregnant_warm",
            characterType: .pregnant,
            category: .warm,
            tags: [],
            assetName: "pregnant_warm"
        ),
        
        //Образы женщины
        OutfitPreset(
            id: "woman_cold",
            characterType: .woman,
            category: .cold,
            tags: [],
            assetName: "woman_cold"
        ),
        OutfitPreset(
            id: "woman_easily_warm_rain",
            characterType: .woman,
            category: .mild,
            tags: [.rain],
            assetName: "woman_easily_warm_rain"
        ),
        OutfitPreset(
            id: "woman_easily_warm",
            characterType: .woman,
            category: .mild,
            tags: [],
            assetName: "woman_easily_warm"
        ),
        OutfitPreset(
            id: "woman_hot_rain",
            characterType: .woman,
            category: .hot,
            tags: [.rain],
            assetName: "woman_hot_rain"
        ),
        OutfitPreset(
            id: "woman_hot",
            characterType: .woman,
            category: .hot,
            tags: [],
            assetName: "woman_hot"
        ),
        OutfitPreset(
            id: "woman_warm_rain",
            characterType: .woman,
            category: .warm,
            tags: [.rain],
            assetName: "woman_warm_rain"
        ),
        OutfitPreset(
            id: "woman_warm",
            characterType: .woman,
            category: .warm,
            tags: [],
            assetName: "woman_warm"
        )
    ]
}
