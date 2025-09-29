import Foundation
import CoreData

struct itemList{
    var title: String
    var priceSign: Bool
    var price: Decimal
    var date: Date
    var category: String
}

class DataManagerList{
    static let shared = DataManagerList()
    var listTransactions : [TransactionEntity] = []
    
    init(){
        fetchAllDayList()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "moneyAnalytics")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllDayList(){
        let req = TransactionEntity.fetchRequest()
        if let lists = try? persistentContainer.viewContext.fetch(req){
            self.listTransactions = lists
        }
    }
    
    func addNewItemInList(itemList: itemList){
        let item = TransactionEntity(context: persistentContainer.viewContext)
        item.title = itemList.title
        item.date = itemList.date
        item.priceSign = itemList.priceSign
        item.price = NSDecimalNumber(decimal: itemList.price)
        item.category = itemList.category
        saveContext()
        fetchAllDayList()
    }
    
    func deleteItem(_ item: TransactionEntity){
        let context = persistentContainer.viewContext
        context.delete(item)
        saveContext()
        fetchAllDayList()
    }
    
}
