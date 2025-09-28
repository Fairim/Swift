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
    var listTransactions : [MainListsEntity] = []
    
    init(){
        fetchAllDayList()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "moneyAnalytics")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllDayList(){
        let req = MainListsEntity.fetchRequest()
        if let lists = try? persistentContainer.viewContext.fetch(req){
            self.listTransactions = lists
        }
    }
    
    func addNewItemInList(itemList: itemList){
        let item = MainListsEntity(context: persistentContainer.viewContext)
        item.title = itemList.title
        item.date = itemList.date
        item.priceSign = itemList.priceSign
        item.price = NSDecimalNumber(decimal: itemList.price)
        item.category = itemList.category
        saveContext()
        fetchAllDayList()
    }
    
}
