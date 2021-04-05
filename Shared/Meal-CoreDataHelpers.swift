//
//  Meal-CoreDataHelpers.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import Foundation

extension AmountDemo {
    var amountName: String {
        name ?? "No amount name"
    }
}

extension IngredientDemo {
    var ingredientName: String {
        name ?? "No ingredient name"
    }
}

extension MadeMeal {
    var thoughtsAuthorId: String {
        author?.idString ?? "No author..."
    }
    
    var thoughtsAuthorName: String {
        author?.name ?? "No name"
    }
    
    var mealThoughts: String {
        thoughts ?? "Thoughts on meal and life?"
    }
    
    var mealDateMade: Date {
        dateMade ?? Date()
    }
}

extension MealDemo {
    var mealName: String {
        name ?? "No Name"
    }
    
    var mealDetail: String {
        detail ?? "No Detail"
    }
    
    var mealImageUrl: URL {
        imageUrl ?? URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1598621202/veggily/5f490612c53b900a6dcdc484.png")!
    }
    
    var mealAuthor: String {
        author?.idString ?? "No author..."
    }
    
    // Helper so that you can use mealIngredientList set in swiftui
    // https://www.hackingwithswift.com/books/ios-swiftui/one-to-many-relationships-with-core-data-swiftui-and-fetchrequest
    
    var mealIngredientListDemoArray: [MealIngredientListDemo] {
        let set = mealIngredientListDemo as? Set<MealIngredientListDemo> ?? []
        return set.sorted {
            $0.idString < $1.idString
        }
    }
    
    static var example: MealDemo {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let meal = MealDemo(context: viewContext)
        meal.imageUrl = URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg")
        meal.createdAt = Date()
        meal.detail = "Meal Detail"
        meal.idString = "1"
        meal.name = "Demo Meal"
        
        return meal
    }
}

extension UserDemo {
    var userName: String {
        name ?? "No name"
    }
    
    var followsArray: [UserDemo] {
        let set = follows as? Set<UserDemo> ?? []
        return set.sorted {
            $0.idString < $1.idString
        }
    }
}

