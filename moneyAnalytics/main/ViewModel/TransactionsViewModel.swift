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
    
    func addTransaction(title: String, category: String, date: Date, price: Decimal, priceSign: Bool){
        dataManager.addNewTransaction(title: title, category: category, date: date, price: price, priceSign: priceSign)
        loadTransactions()
    }
    
    func deleteTransaction(_ transaction: TransactionEntity){
        dataManager.deleteTransaction(transaction: transaction)
        loadTransactions()
    }
}
