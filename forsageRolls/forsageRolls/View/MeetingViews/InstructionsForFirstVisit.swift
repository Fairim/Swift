enum InstructionsForFirstVisit: CaseIterable {
    case wideSelection
    case fastDelivery
    case orderTracking
    case specialOffers
    
    func getImage() -> String {
        switch self {
        case .wideSelection: return "wideSelection"
        case .fastDelivery: return "fastDelivery"
        case .orderTracking: return "orderTracking"
        case .specialOffers: return "specialOffers"
        }
    }
    
    func getMainInfo() -> String {
        switch self {
        case .wideSelection: return "Широкий выбор"
        case .fastDelivery: return "Быстрая доставка"
        case .orderTracking: return "Слежение за заказом"
        case .specialOffers: return "Спецпредложения"
        }
    }
    
    func getSubInfo() -> String {
        switch self {
        case .wideSelection: return "Более 100 позиций."
        case .fastDelivery: return "Доставка за 30 минут."
        case .orderTracking: return "Cледите за заказом в реальном времени."
        case .specialOffers: return "Недельные предложения и скидки."
        }
    }
}
