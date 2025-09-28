import Foundation

class SettingViewModel: ObservableObject {
    private let settingsManager: SettingManager
    
    @Published var userName: String = ""
    @Published var firstBuild: Bool = false
    
    init(settingsManager: SettingManager = SettingManager()) {
        self.settingsManager = settingsManager
        loadSettings()
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
    
    func replaceBuild(){
        if firstBuild == false{
            settingsManager.firstBuild = true
            firstBuild = true
        }
    }
}
