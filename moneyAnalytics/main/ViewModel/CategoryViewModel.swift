import Foundation

class CategoryViewModel: ObservableObject{
    @Published var categoriesList: [CategoriesEntity] = []
    private let dataManager = DataManager.shared
    
    init(){
        loadCategories()
    }
    
    private func loadCategories(){
        categoriesList = dataManager.fetchCategories()
    }
    
    func addCategory(nameCategory: String){
        dataManager.addNewCategory(nameCategory: nameCategory)
        loadCategories()
    }
    
    func deleteCategory(category: CategoriesEntity){
        dataManager.deleteCategory(category)
        loadCategories()
    }
    
    func findCategory(nameCategory: String) -> CategoriesEntity?{
        return dataManager.findCategory(byName: nameCategory)
    }
}
