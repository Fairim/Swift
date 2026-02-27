struct CityResponse: Codable {
    let geonames: [MainCityResponse]
}

struct MainCityResponse: Codable {
    let adminCode: String
    let lon: String
    let distance: String?
    let geonameId: Int
    let toponymName: String
    let countryId: String
    let fcl: String
    let population: Int
    let countryCode: String
    let name: String
    let fclName: String
    let adminCodes: AdminCodes?
    let countryName: String
    let fcodeName: String
    let adminName: String?
    let lat: String
    let fcode: String
    
    enum CodingKeys: String, CodingKey {
        case adminCode = "adminCode1"
        case lon = "lng"
        case distance
        case geonameId
        case toponymName
        case countryId
        case fcl
        case population
        case countryCode
        case name
        case fclName
        case adminCodes = "adminCodes1"
        case countryName
        case fcodeName
        case adminName = "adminName1"
        case lat
        case fcode
    }
    
    func takeCity() -> String {
        return toponymName
    }

    func takeCountry() -> String {
        return countryName
    }
    
    func takeCoordinates() -> [String] {
        return [lat, lon]
    }
}

struct AdminCodes: Codable {
    let id: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "ISO3166_2"
    }
}

