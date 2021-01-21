//
//  ListOfMealIngredientsCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/14/21.
//

import SwiftUI

struct ListOfMealIngredientsCoreDataView: View {
    let ingredientList: [MealIngredientListDemo]
    
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
                        Text("\(ingredient.amountDemo?.name ?? "No amount") - \(ingredient.ingredientDemo?.name ?? "No ingredient")")
                            .padding()
                        Spacer()
                        
//                        if didCreateMeal {
//                            Button(action: {
//                                withAnimation(.spring()) {
//                                    self.networkingController.deleteMealIngredientList(mealIngredientListId: ingredient.id, ingredientId: ingredient.ingredient!.id, mealId: mealId)
//                                }
//                            }) {
//                                Image(systemName: "trash")
//                                    .font(.system(size: 17, weight: .bold))
//                                    .foregroundColor(.white)
//                                    .padding(.all, 10)
//                                    .background(Color.black.opacity(0.6))
//                                    .clipShape(Circle())
//                            }.padding(.trailing)
//                        }
                        
                    }
                    Divider()
                }
            } else {
                Text("No ingredients have been added to this meal").padding()
            }
            Spacer()
        }.padding(.top, 50)
        
    }
}
//
//struct ListOfMealIngredientsCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOfMealIngredientsCoreDataView()
//    }
//}
