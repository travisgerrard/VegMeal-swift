//
//  AllMealsCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import SwiftUI
import CoreData

struct AllMealsCoreDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController

    let meals: FetchRequest<MealDemo>
    
    let c = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)

    init() {
        meals = FetchRequest<MealDemo>(
            entity: MealDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MealDemo.name, ascending: false)
            ])
    }
    
    func loadMealDemo() {
        let query = AllMealsDemoQuery()
        ApolloController.shared.apollo.fetch(query: query) { result in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let graphQLResult):
                print("!!!!")
                if let data = graphQLResult.data {
                    if let allMeals = data.allMeals {
                        for meal in allMeals {
                            if let mealDemoFragment = meal?.fragments.mealDemoFragment {
                                
                                // Loads all meals into DB
                                let mealForDB = MealDemo.object(in:managedObjectContext, withFragment: mealDemoFragment)
                                mealDemoFragment.ingredientList.forEach {
                                    
                                    // Loads the mealIngredientList in the DB
                                    let mealIngredientListFragment =  MealIngredientListDemo.object(in:managedObjectContext, withFragment: $0.fragments.mealIngredientListFragment)
                                    
                                    // Connects mealIngredientList to the meal
                                    mealForDB?.mutableSetValue(forKey: "mealIngredientListDemo").add(mealIngredientListFragment!)
                                    
                                    // Loads ingredients and amounts into DB and links them to mealIngredientList
                                    if let ingredientFragment = $0.fragments.mealIngredientListFragment.ingredient?.fragments.ingredientFragment {
                                        let ID = IngredientDemo.object(in:managedObjectContext, withFragment: ingredientFragment)
                                        mealIngredientListFragment?.ingredientDemo = ID
                                    }
                                    if let amountFragment = $0.fragments.mealIngredientListFragment.amount?.fragments.amountFragment {
                                        let AD = AmountDemo.object(in:managedObjectContext, withFragment: amountFragment)
                                        mealIngredientListFragment?.amountDemo = AD
                                    }
                                }
                            }
                        }
//                        try? managedObjectContext.save()
                    }
                }
            }
        }
    }

    
    var body: some View {
        VStack {
            if meals.wrappedValue.isEmpty {
                Text("There is nothing here right now")
                    .foregroundColor(.secondary)
            } else {
                
                ScrollView {
                    LazyVGrid(columns: [c], spacing: 20) {
                        ForEach(meals.wrappedValue) { meal in
                            NavigationLink(
                                destination: MealCoreDataView(meal: meal),
                                label: {
                                    MealFragmentCoreDataView(meal: meal)
                                })
//                            Text("\(meal.mealName)")
//                            ForEach(meal.mealIngredientListDemoArray, id: \.self) {mealIngredientListDemo in
//                                Text("\(mealIngredientListDemo.amountDemo?.name ?? "No Amount Name") - \(mealIngredientListDemo.ingredientDemo?.name ?? "No Ingredient Name")")
//                            }
                        }
                    }
                }
                Button("Delete Meals", action: {
                    let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = MealDemo.fetchRequest()
                    let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
                    _ = try? managedObjectContext.execute(batchDeleteRequest1)
                    try? managedObjectContext.save()
                    dataController.save()

                    print("Deleted?")
                }).padding()
            }
        }.onAppear {
            self.loadMealDemo()
        }
        
        
    }
}

struct AllMealsCoreDataView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        AllMealsCoreDataView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .environmentObject(ApolloNetworkingController())
    }
}
