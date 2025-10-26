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
    
    func getUsername() -> String? {
        return userInfo?.username
    }
}
