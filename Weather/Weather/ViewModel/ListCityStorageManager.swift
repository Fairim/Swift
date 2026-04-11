import UIKit
import CoreData

class ListCityStorageManager {
    static let shared = ListCityStorageManager()
    private let networkManager = NetworkManager.shared
    private let context = CoreDataStack.shared.context
    
    private init() {}
    
    func addCity(cityName: String, lat: Double, lon: Double, pos: Int16) throws {
        let cityInfo = CityListToolbar(context: context)
        
        cityInfo.name = cityName
        cityInfo.lastOpen = Date()
        cityInfo.lat = lat
        cityInfo.lon = lon
        cityInfo.positionInList = pos
        
        try CoreDataStack.shared.saveContext()
    }
    
    func fetchAllCities() -> [CityListToolbar] {
        let fetchRequest: NSFetchRequest<CityListToolbar> = CityListToolbar.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Failed to fetch cities: \(error)")
        }
    }
    
    func delete(city: CityListToolbar) throws {
        context.delete(city)
        try context.save()
    }
    
}
