//
//  CategoriesEntity+CoreDataProperties.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 27/09/2025.
//
//

import Foundation
import CoreData


extension CategoriesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoriesEntity> {
        return NSFetchRequest<CategoriesEntity>(entityName: "CategoriesEntity")
    }

    @NSManaged public var nameCategory: String?

}

extension CategoriesEntity : Identifiable {

}
