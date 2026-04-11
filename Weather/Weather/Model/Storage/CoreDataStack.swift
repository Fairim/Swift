//
//  CoreDataStack.swift
//  Weather
//
//  Created by Руслан Ахметсафин on 11.04.2026.
//

import UIKit
import CoreData

class CoreDataStack{
    static let shared = CoreDataStack()
        
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
