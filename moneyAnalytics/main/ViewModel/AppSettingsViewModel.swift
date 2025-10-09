import Foundation

class SettingViewModel: ObservableObject {
    static let shared = SettingViewModel()
    private let settingsManager = SettingManager()
    private let dm = DataManager.shared
    
    @Published var userName: String = "Гость"
    @Published var firstBuild: Bool = false
    
    init() {
        loadSettings()
        if !firstBuild{
            loadBaseCategories()
            replaceBuild()
        }
    }
    
    func loadSettings(){
        userName = settingsManager.userName
        firstBuild = settingsManager.firstBuild
    }
    
    func saveUserName(_ name: String){
        settingsManager.userName = name
        userName = name
    }
    
    func getNameUser() -> String{
        return userName
    }
    
    func getFirstBuild() -> Bool{
        return firstBuild
    }
    
    private func loadBaseCategories(){
        print("Мы сюда дошли!")
        guard let path = Bundle.main.path(forResource: "mainCategories", ofType: "plist")
        else{
            print("Данного файла не существует или не получилось открыть!")
            return
        }
        
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            if let categoriesDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]{
                
                for (_, value) in categoriesDict{
                    dm.addNewCategory(nameCategory: value as! String)
                }
            }
            print("")
        }catch{
            print("\(error)")
        }
    }
    
    func replaceBuild(){
        if firstBuild == false{
            settingsManager.firstBuild = true
            firstBuild = true
        }
    }
}
