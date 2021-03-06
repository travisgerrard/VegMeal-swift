//
//  MealFragment_Extentions.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/16/20.
//

import SwiftUI

extension MealFragment: Identifiable {
    var dateCreated: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if createdAt != nil {
            let dateCompletedStr = createdAt
            let dateCompletedDate = dateFormatter.date(from: dateCompletedStr!)
            return dateCompletedDate
        } else {
            return nil
        }
        
    }
    
    // Static makes it useable in previews
    static var example: MealFragment {
        MealFragment(
            id: "5f4c7bfdf818ca3c74eb7d6d",
            name: "Test",
            description: "Text description",
            createdAt: "2021-01-02T03:22:37.593Z",
            mealImage: MealFragment.MealImage(
                publicUrlTransformed:
                    "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg"
            ),
            author: MealFragment.Author(id: "1"),
            ingredientList: [
                        MealFragment.IngredientList(
                            id: "1",
                            ingredient:
                                MealFragment.IngredientList.Ingredient(
                                    id: "1",
                                    name: "butternut squash"),
                            amount:
                                MealFragment.IngredientList.Amount(
                                    id: "1",
                                    name: "1 & 1/2 cups")
                        ),
                        MealFragment.IngredientList(
                            id: "2",
                            ingredient:
                                MealFragment.IngredientList.Ingredient(
                                    id: "2",
                                    name: "olive oil"),
                            amount:
                                MealFragment.IngredientList.Amount(
                                    id: "2",
                                    name: "2 tbsp")
                        ),
                        MealFragment.IngredientList(
                            id: "3",
                            ingredient:
                                MealFragment.IngredientList.Ingredient(
                                    id: "3",
                                    name: "salt"),
                            amount:
                                MealFragment.IngredientList.Amount(
                                    id: "3",
                                    name: "2 tsp")
                        )])
    }
}

extension MealFragment.IngredientList: Identifiable {
    
}
