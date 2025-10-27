import Foundation

struct UserProfile: Codable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let middleName: String
    let gender: String
    let photoPath: String?
    let studentId: Int?
    let group: Group
}

struct Group: Codable {
    let id: Int?
    let name: String?
    let instituteName: String?
    let specialization: String?
    let speciality: String?
    let yearStart: Int?
    let yearEnd: Int?
}

class ProfileViewModel: ObservableObject {
    private var accessToken: String
    private let profileService = ProfileService()
    @Published var userInfo: UserProfile?
    
    init(viewModel: AuthViewModel){
        accessToken = viewModel.getAccessToken()
        Task {
            await fetchUserInfo()
        }
    }
    
    private func fetchUserInfo() async{
        do {
            try userInfo = await profileService.fetchUserProfile(accessToken: accessToken)
        } catch {
            print("Не получилось :(")
        }
    }
    
    func getUsername() -> String {
        return userInfo?.username ?? ""
    }
    
    func getFullName() -> String {
        return "\(userInfo?.firstName ?? "") \(userInfo?.middleName ?? "") \(userInfo?.lastName ?? "")"
    }
    
    func getGender() -> String {
        return userInfo?.gender ?? ""
    }
    
    func getGroupName() -> String {
        return userInfo?.group.name ?? ""
    }
    
    func getInstituteName() -> String {
        return userInfo?.group.instituteName ?? ""
    }
    
    func getSpecialization() -> String {
        return userInfo?.group.specialization ?? ""
    }
    
    func getPhotoPath() -> String{
        return userInfo?.photoPath ?? ""
    }
    
    func checkLoadUserData() -> Bool {
        if userInfo != nil{
            return true
        }
        return false
    }
}
