import Foundation

class CategoryViewModel: ObservableObject{
    @Published var categoriesList: [CategoriesEntity] = []
    @Published var categoriesListNamed: [String] = []
    private let dataManager = DataManager.shared
    
    init(){
        loadCategories()
    }
    
    private func loadCategories(){
        categoriesList = dataManager.fetchCategories()
        categoriesListNamed.removeAll()
        for entity in categoriesList{
            if entity.nameCategory != "Доход"{
                categoriesListNamed.append(entity.nameCategory)
            }
        }
    }
    
    func addCategory(nameCategory: String){
        var flag: Bool = true
        for name in categoriesListNamed{
            if name == nameCategory{
                flag = false
            }
        }
        if flag{
            dataManager.addNewCategory(nameCategory: nameCategory)
            loadCategories()
        }
    }
    
    func deleteCategory(category: CategoriesEntity){
        dataManager.deleteCategory(category)
        loadCategories()
    }
    
    func findCategory(nameCategory: String) -> CategoriesEntity?{
        return dataManager.findCategory(byName: nameCategory)
    }
}
