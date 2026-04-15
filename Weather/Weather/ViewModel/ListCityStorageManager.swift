import UIKit
import CoreData

class ListCityStorageManager {
    static let shared = ListCityStorageManager()
    private let context = CoreDataStack.shared.context
    
    private init() {}
    
    func upsertCity(
        cityName: String,
        lat: Double,
        lon: Double,
        currentTemperature: Int,
        currentIcon: String,
        position: Int16? = nil
    ) throws {
        let cityInfo = existingCity(name: cityName, lat: lat, lon: lon) ?? CityListToolbar(context: context)
        let isNewObject = cityInfo.objectID.isTemporaryID
        let now = Date()
        
        cityInfo.name = cityName
        cityInfo.lastOpen = now
        cityInfo.lat = lat
        cityInfo.lon = lon
        cityInfo.currentIcon = currentIcon
        
        if let position {
            cityInfo.positionInList = position
        } else if isNewObject {
            cityInfo.positionInList = nextPosition()
        }

        try CoreDataStack.shared.saveContext()
    }
    
    func fetchAllCities() -> [CityListToolbar] {
        let fetchRequest: NSFetchRequest<CityListToolbar> = CityListToolbar.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "positionInList", ascending: true),
            NSSortDescriptor(key: "lastOpen", ascending: false)
        ]
        
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
    
    private func existingCity(name: String, lat: Double, lon: Double) -> CityListToolbar? {
        let fetchRequest: NSFetchRequest<CityListToolbar> = CityListToolbar.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !normalizedName.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name =[c] %@", normalizedName)
        } else {
            let delta = 0.0001
            fetchRequest.predicate = NSPredicate(
                format: "lat >= %lf AND lat <= %lf AND lon >= %lf AND lon <= %lf",
                lat - delta, lat + delta, lon - delta, lon + delta
            )
        }
        
        return try? context.fetch(fetchRequest).first
    }
    
    private func nextPosition() -> Int16 {
        let fetchRequest: NSFetchRequest<CityListToolbar> = CityListToolbar.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "positionInList", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let lastPosition = (try? context.fetch(fetchRequest).first?.positionInList) ?? -1
        return lastPosition + 1
    }
    
}
