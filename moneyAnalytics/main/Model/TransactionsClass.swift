import Foundation

class Transactions{
    var title : String
    var date: Date
    var price: Decimal
    var priceSign: Bool
    var category: String
    
    init(){
        title = "Заголовок"
        date = Date()
        price = 200
        priceSign = true
        category = "Работа"
    }
}
