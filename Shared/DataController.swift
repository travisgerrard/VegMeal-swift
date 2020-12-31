//
//  DataController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/24/20.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        
        // This is so preview's are new each time we run them
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
//        
//        do {
////            try dataController.createSampleData()
//        } catch {
//            fatalError("Fatal error createg preview: \(error.localizedDescription)")
//        }
        
        return dataController
    }()
    
//    func createSampleData() throws {
//        let viewContext = container.viewContext
//
//        for i in 1...5 {
//            let meal = Meal(context: viewContext)
//            meal.id = UUID().uuidString
//            meal.name = "Meal \(i)"
//            meal.detail = "IDI page 0\(i)"
//            meal.author = "Name \(i)"
//            meal.createdAt = Date()
//            meal.photoURL = URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1598621202/veggily/5f490612c53b900a6dcdc484.png")
//        }
//        try viewContext.save()
//    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Meal.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

    }
}
