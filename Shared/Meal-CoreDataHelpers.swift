//
//  Meal-CoreDataHelpers.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import Foundation

extension MealDemo {
    var mealName: String {
        name ?? "No Name"
    }
    
    var mealDetail: String {
        detail ?? "No Detail"
    }
    
    var mealImageUrl: URL {
        imageUrl ?? URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg")!
    }
    
    // Helper so that you can use mealIngredientList set in swiftui
    // https://www.hackingwithswift.com/books/ios-swiftui/one-to-many-relationships-with-core-data-swiftui-and-fetchrequest
    var mealIngredientListDemoArray: [MealIngredientListDemo] {
        let set = mealIngredientListDemo as? Set<MealIngredientListDemo> ?? []
        return set.sorted {
            $0.idString < $1.idString
        }
    }
}

extension Meal {
    var mealName: String {
        name ?? "No Name"
    }
    
    var mealDetail: String {
        detail ?? "No Detail"
    }
    
    var mealImage: URL {
        mealImageUrl ?? URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg")!
    }
    
    static var example: Meal {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let meal = Meal(context: viewContext)
        meal.id = UUID()
        meal.name = "Example MealName"
        meal.detail = "Example MealDetail"
        meal.createdAt = Date()
        meal.mealImageUrl = URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg")
//        meal.author = user
        
//        for k in 1...10 {
//            let ingredient = Ingredient(context: viewContext)
//            ingredient.id = UUID()
//            ingredient.name = "Ingredient \(k)"
//            let amount = Amount(context: viewContext)
//            amount.id = UUID()
//            amount.name = "Amount \(k)"
//            let mealIngredientList = MealIngredientList(context: viewContext)
//            mealIngredientList.id = UUID()
//            mealIngredientList.amount = amount
//            mealIngredientList.ingredient = ingredient
////            mealIngredientList.meal = [meal]
//        }
        
        return meal
    }
}
