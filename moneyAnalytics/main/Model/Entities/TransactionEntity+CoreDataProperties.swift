//
//  TransactionEntity+CoreDataProperties.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 02/10/2025.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var priceSign: Bool
    @NSManaged public var title: String?
    @NSManaged public var category: CategoriesEntity?

}

extension TransactionEntity : Identifiable {

}
