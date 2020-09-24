//
//  ListOfMealIngredients.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

struct ListOfMealIngredients: View {
    @Binding var listOfIngredients: [MealFragment.IngredientList]
    
    var body: some View {
        VStack {
            List(listOfIngredients) { ingredient in
                HStack {
                    Text("\(ingredient.amount?.name ?? "No amount") - \(ingredient.ingredient?.name ?? "No ingredient")")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Button(action: {
                       
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                }
                
            }
        }
    }
}

struct ListOfMealIngredients_Previews: PreviewProvider {
    @State static var listOfIngredients = [
        MealFragment.IngredientList(id: "1", ingredient: MealFragment.IngredientList.Ingredient(id: "1", name: "Apple"), amount: MealFragment.IngredientList.Amount(id: "1", name: "1 cup")),
        MealFragment.IngredientList(id: "2", ingredient: MealFragment.IngredientList.Ingredient(id: "1", name: "Pear"), amount: MealFragment.IngredientList.Amount(id: "1", name: "1 cup")),
        MealFragment.IngredientList(id: "3", ingredient: MealFragment.IngredientList.Ingredient(id: "1", name: "Plum"), amount: MealFragment.IngredientList.Amount(id: "1", name: "1 cup")),
        MealFragment.IngredientList(id: "4", ingredient: MealFragment.IngredientList.Ingredient(id: "1", name: "Banana"), amount: MealFragment.IngredientList.Amount(id: "1", name: "1 cup")),
        MealFragment.IngredientList(id: "5", ingredient: MealFragment.IngredientList.Ingredient(id: "1", name: "Grapes"), amount: MealFragment.IngredientList.Amount(id: "1", name: "1 cup"))
    ]
    
    static var previews: some View {
        ListOfMealIngredients(listOfIngredients: $listOfIngredients)
            .environmentObject(ApolloNetworkingController())
    }
}
