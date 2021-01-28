//
//  ListOfMealIngredientsCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/14/21.
//

import SwiftUI

struct ListOfMealIngredientsCoreDataView: View {
    let ingredientList: FetchRequest<MealIngredientListDemo>
    let didCreateMeal: Bool
    let meal: MealDemo

    @Environment(\.managedObjectContext) var managedObjectContext



    init(meal: MealDemo, didCreateMeal: Bool) {
        self.meal = meal
        self.didCreateMeal = didCreateMeal
    
        ingredientList = FetchRequest<MealIngredientListDemo>(
            entity: MealIngredientListDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MealIngredientListDemo.idString, ascending: false)
            ],
            predicate: NSPredicate(format: "mealDemo = %@", meal))
    }
    
    func deleteMealIngredientList(mealIngredientList: MealIngredientListDemo) {
        let mutation = DeleteMealIngredientListMutation(mealIngredientListId: mealIngredientList.idString, ingredientId: mealIngredientList.ingredientDemo!.idString, mealId: meal.idString)

        mealIngredientList.mealDemo = nil
        meal.mutableSetValue(forKey: "mealIngredientListDemo").remove(mealIngredientList)

        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            
            case .failure(let error):
                print(error)

                
            case .success:
                print("Success!")
                // By putting the below here, it deletes...
                // For somereason, after this code runes, the laodMealDemo runs in AllMealsCoreDataView...?
                meal.mutableSetValue(forKey: "mealIngredientListDemo").remove(mealIngredientList)
                managedObjectContext.delete(mealIngredientList)
                try? managedObjectContext.save()

            }
            
        }

    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Ingredients")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal).padding(.bottom)
                Spacer()
            }
            if ingredientList.wrappedValue.count > 0 {
                ForEach(ingredientList.wrappedValue) { ingredient in
                    HStack(spacing: 1) {
                        Text("\(ingredient.amountDemo?.name ?? "No amount") - \(ingredient.ingredientDemo?.name ?? "No ingredient")")
                            .padding()
                        Spacer()
                        
                        if didCreateMeal {
                            Button(action: {
                                withAnimation(.spring()) {
                                   // Trash ingredient...
                                    deleteMealIngredientList(mealIngredientList: ingredient)
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
        }.padding(.top, 50)
        
    }
}
//
//struct ListOfMealIngredientsCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOfMealIngredientsCoreDataView()
//    }
//}
