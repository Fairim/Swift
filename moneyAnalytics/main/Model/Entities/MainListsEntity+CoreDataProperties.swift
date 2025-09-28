//
//  MainListsEntity+CoreDataProperties.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 27/09/2025.
//
//

import Foundation
import CoreData


extension MainListsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainListsEntity> {
        return NSFetchRequest<MainListsEntity>(entityName: "MainListsEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var priceSign: Bool
    @NSManaged public var title: String?

}

extension MainListsEntity : Identifiable {
    func deleteItemList(){
        managedObjectContext?.delete(self)
        
        try? managedObjectContext?.saveContext()
    }
}
