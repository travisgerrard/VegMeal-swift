//
//  DataController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "VeggilyDataModel")
        print(container)
        
        // This is so preview's are new each time we run them
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error)

                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error createg preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let user = User(context: viewContext)
            user.id = UUID()
            user.name = "UserName \(i)"
            user.email = "UserEmail \(i)"
            
            
            for j in 1...10 {
                let meal = Meal(context: viewContext)
                meal.id = UUID()
                meal.name = "MealName \(j)"
                meal.detail = "MealDetail \(j)"
                meal.createdAt = Date()
                meal.mealImageUrl = URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg")
                meal.author = user
                
                for k in 1...10 {
                    let ingredient = Ingredient(context: viewContext)
                    ingredient.id = UUID()
                    ingredient.name = "Ingredient \(k)"
                    let amount = Amount(context: viewContext)
                    amount.id = UUID()
                    amount.name = "Amount \(k)"
                    let mealIngredientList = MealIngredientList(context: viewContext)
                    mealIngredientList.id = UUID()
                    mealIngredientList.amount = amount
                    mealIngredientList.ingredient = ingredient
                    mealIngredientList.meal = [meal]
                }
                
            
            }
            
            
        }
        try viewContext.save()

    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        
    }
}
