import Foundation

enum CharacterType: String, CaseIterable {
    case man
    case woman
    case pregnant

    var title: String {
        switch self {
        case .man:
            return "Мужчина"
        case .woman:
            return "Женщина"
        case .pregnant:
            return "Беременная"
        }
    }

    var defaultAssetName: String {
        switch self {
        case .man:
            return "man_easily_warm"
        case .woman:
            return "woman_easily_warm"
        case .pregnant:
            return "pregnant_easily_warm"
        }
    }
}
