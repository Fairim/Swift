import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [TransactionEntity] = []
    private let dataManager = DataManager.shared
    
    init(){
        loadTransactions()
    }
    
    func loadTransactions(){
        transactions = dataManager.fetchTransactions()
    }
    
    func addTransaction(title: String, category: String, date: Date, price: String, priceSign: Bool) -> Int{
        var flag = 0
        
        if !price.containsOnlyDigits || price.isEmpty{
            flag = 1
        }else if title.isEmpty{
            flag = 2
        }else{
            dataManager.addNewTransaction(title: title, category: category, date: date, price: NSDecimalNumber(string: price) as Decimal, priceSign: priceSign)
            loadTransactions()
        }
        return flag
    }
    
    func deleteTransaction(_ transaction: TransactionEntity){
        dataManager.deleteTransaction(transaction: transaction)
        loadTransactions()
    }
}
