import Foundation

class SettingManager{
    private let defaults = UserDefaults.standard
    
    var userName: String{
        get { defaults.string(forKey: "userName") ?? "Guest" }
        set { defaults.set(newValue, forKey: "userName") }
    }
    
    var firstBuild: Bool{
        get { defaults.bool(forKey: "firstBuild")}
        set { defaults.set(newValue, forKey: "firstBuild") }
    }
}
