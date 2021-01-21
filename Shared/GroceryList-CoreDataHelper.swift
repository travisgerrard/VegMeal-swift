//
//  GroceryList-CoreDataHelper.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/20/21.
//

import Foundation

extension GroceryList {
    var options: [Int: String] {
        [
            0: "none",
            1: "produce",
            2: "bakery",
            3: "frozen",
            4: "baking & spices",
            5: "nuts, seeds & dried fruit",
            6: "rice, grains & beans",
            7: "canned & jarred goods",
            8: "oils, sauces & condiments",
            9: "ethnic",
            10: "refrigerated",
        ]
    }
    
    var groceryIngredientName: String {
        ingredient?.name ?? "No ingredient name"
    }
    
    var groceryAmountName: String {
        amount?.name ?? "No amount name"
    }
    
}

extension MealList {
    var mealListName: String {
        meal?.name ?? "No meal name"
    }
    
    var mealListDesc: String {
        meal?.detail ?? "No meal description"
    }
}
