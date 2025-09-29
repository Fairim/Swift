//
//  MainListsEntity+CoreDataProperties.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 27/09/2025.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var priceSign: Bool
    @NSManaged public var title: String?

}

extension TransactionEntity : Identifiable {
    
}
