import Foundation
import CoreData

struct itemList{
    var title: String
    var priceSign: Bool
    var price: Decimal
    var date: Date
    var category: String
}

class DataManager{
    static let shared = DataManager()
    
    private init(){
        guard context.persistentStoreCoordinator != nil else {
            print("Context is not ready")
            return
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "transactionStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Обозначение контекста в главном потоке
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Ошибка сохранения \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// Расширение класса для работы с Категориями
extension DataManager {
    func fetchCategories() -> [CategoriesEntity]{
        let request: NSFetchRequest<CategoriesEntity> = CategoriesEntity.fetchRequest()
        do{
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки категорий: \(error)")
            return []
        }
    }
    
    func addNewCategory(nameCategory: String){
        let category = CategoriesEntity(context: context)
        category.id = UUID()
        category.nameCategory = nameCategory
        saveContext()
    }
    
    func deleteCategory(_ category: CategoriesEntity){
        context.delete(category)
        saveContext()
    }
    
    
    func findCategory(byName name: String) -> CategoriesEntity? {
        let request: NSFetchRequest<CategoriesEntity> = CategoriesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "nameCategory == %@", name)
        
        do {
            let categories = try context.fetch(request)
            return categories.first
        } catch {
            print("Ошибка поиска категории: \(error)")
            return nil
        }
    }
    
}

//Расширение класса для работы с Транзакциями
extension DataManager{
    func fetchTransactions() -> [TransactionEntity]{
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки данных: \(error)")
            return []
        }
    }
    
    func addNewTransaction(title: String, category: String, date: Date, price: Decimal, priceSign: Bool){
        let transaction = TransactionEntity(context: context)
        transaction.title = title
        transaction.category = findCategory(byName: category)
        //Существование категории не нужно проверять, т.к. мы выбираем его из выпадающего списка
        transaction.price = (price) as NSDecimalNumber
        transaction.date = Date()
        transaction.priceSign = priceSign
        saveContext()
    }
    
    func deleteTransaction(transaction: TransactionEntity){
        context.delete(transaction)
        saveContext()
    }
}
