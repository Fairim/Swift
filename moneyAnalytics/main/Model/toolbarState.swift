enum ToolbarItems: CaseIterable{
    case transaction
    case analytic
    case profile
    
    var title: String{
        switch self{
        case.transaction: return "Транзакции"
        case.analytic: return "Аналитика"
        case.profile: return "Профиль"
        }
    }
    
    var iconName: String{
        switch self{
        case.transaction: return "chart.bar.horizontal.page"
        case.analytic: return "chart.xyaxis.line"
        case .profile: return "person"
        }
    }
}

struct ToolbarState{
    var selectedItem: ToolbarItems
    var items: [ToolbarItems]
    
    init(selectedItem: ToolbarItems = .transaction){
        self.selectedItem = selectedItem
        self.items = ToolbarItems.allCases
    }
}
