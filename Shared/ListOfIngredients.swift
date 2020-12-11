//
//  ListOfIngredients.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/30/20.
//

import SwiftUI

struct ListOfIngredients: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.

    @Binding var ingredientList: [MealFragment.IngredientList]
    let didCreateMeal: Bool
    let mealId: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Ingredients")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal).padding(.bottom)
                Spacer()
            }
            if ingredientList.count > 0 {
                ForEach(ingredientList) { ingredient in
                    HStack(spacing: 1) {
                        Text("\(ingredient.amount?.name ?? "No amount") - \(ingredient.ingredient?.name ?? "No ingredient")")
                            .padding()
                        Spacer()
                        
                        if didCreateMeal {
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.networkingController.deleteMealIngredientList(mealIngredientListId: ingredient.id, ingredientId: ingredient.ingredient!.id, mealId: mealId)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.all, 10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }.padding(.trailing)
                        }
                        
                    }
                    Divider()
                }
            } else {
                Text("No ingredients have been added to this meal").padding()
            }
            Spacer()
        }
    }
}

struct ListOfIngredients_Previews: PreviewProvider {
    static var previews: some View {
        ListOfIngredients(ingredientList: .constant([
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
            )
        ]), didCreateMeal: true, mealId: "12345").environmentObject(ApolloNetworkingController())

    }
}
