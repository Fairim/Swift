import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [TransactionEntity] = []
    private let dataManager = DataManagerList.shared
    
    init(){
        loadTransactions()
    }
    
    func loadTransactions(){
        transactions = dataManager.listTransactions
    }
    
    func addTransaction(title: String, category: String, date: Date, price: Decimal, priceSign: Bool){
        let newItem = itemList(
            title: title,
            priceSign: priceSign,
            price: price,
            date: date,
            category: category
        )
        dataManager.addNewItemInList(itemList: newItem)
        loadTransactions()
    }
    
    func deleteTransaction(_ transaction: TransactionEntity){
        dataManager.deleteItem(transaction)
        loadTransactions()
    }
    
}
