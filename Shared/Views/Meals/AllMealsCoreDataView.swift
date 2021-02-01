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
    @AppStorage("userid") var userid = ""

    let c = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)

    @FetchRequest(entity: MealDemo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \MealDemo.name, ascending: true)]) var meals: FetchedResults<MealDemo> // Even though we
    
 
    
    func loadUser() {
        let query = GetLoggedinUserWithFollowersQuery(id: userid)
        
        ApolloController.shared.apollo.fetch(query: query) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    if let allUsers = data.allUsers {
                        if allUsers.count > 0 {
                            if let currentUser = allUsers[0]?.fragments.userDemoFragment {
                                let currentUserDB = UserDemo.object(in: managedObjectContext, withFragment: currentUser)
                                
                                allUsers[0]?.follows.forEach {
                                    let followsUserDB = UserDemo.object(in: managedObjectContext, withFragment: $0.fragments.userDemoFragment)
                                    
                                    currentUserDB?.mutableSetValue(forKey: "follows").add(followsUserDB!)
                                    
                                }
                                try? managedObjectContext.save()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func loadIngredientsAandAmounts() {
        let query = AllAmountsAndIngredientsQuery()
        ApolloController.shared.apollo.fetch(query: query) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    if let allAmounts = data.allAmounts {
                        for amount in allAmounts {
                            if let amountFragment = amount?.fragments.amountFragment {
                                _ = AmountDemo.object(in: managedObjectContext, withFragment: amountFragment)
                            }
                        }
                    }
                    if let allIngredients = data.allIngredients {
                        for ingredient in allIngredients {
                            if let ingredientFragment = ingredient?.fragments.ingredientFragment {
                                _ = IngredientDemo.object(in: managedObjectContext, withFragment: ingredientFragment)
                            }
                        }
                    }
                }
            }
        }
    }

    struct FlatLinkStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
        }
    }
    
    var body: some View {
        VStack {
            if meals.isEmpty {
                Text("There is nothing here right now")
                    .foregroundColor(.secondary)
            } else {
                
                ScrollView {
                    LazyVGrid(columns: [c], spacing: 20) {
                        ForEach(meals) { meal in
                            NavigationLink(
                                destination: MealCoreDataView(meal: meal),
                                label: {
                                    MealFragmentCoreDataView(meal: meal)
                                }).buttonStyle(FlatLinkStyle())
                        }
                    }
                }
//                Button("Delete Meals", action: {
//                    let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = IngredientDemo.fetchRequest()
//                    let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest1)
//
//                    let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = AmountDemo.fetchRequest()
//                    let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest2)
//
//                    let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = GroceryList.fetchRequest()
//                    let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest3)
//
//                    let fetchRequest4: NSFetchRequest<NSFetchRequestResult> = MadeMeal.fetchRequest()
//                    let batchDeleteRequest4 = NSBatchDeleteRequest(fetchRequest: fetchRequest4)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest4)
//
//                    let fetchRequest5: NSFetchRequest<NSFetchRequestResult> = MealIngredientListDemo.fetchRequest()
//                    let batchDeleteRequest5 = NSBatchDeleteRequest(fetchRequest: fetchRequest5)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest5)
//
//
//                    let fetchRequest6: NSFetchRequest<NSFetchRequestResult> = MealList.fetchRequest()
//                    let batchDeleteRequest6 = NSBatchDeleteRequest(fetchRequest: fetchRequest6)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest6)
//
//                    let fetchRequest7: NSFetchRequest<NSFetchRequestResult> = MealDemo.fetchRequest()
//                    let batchDeleteRequest7 = NSBatchDeleteRequest(fetchRequest: fetchRequest7)
//                    _ = try? managedObjectContext.execute(batchDeleteRequest7)
//
//
//                    try? managedObjectContext.save()
//                    dataController.save()
//
//                    print("Deleted?")
//                }).padding()
            }
        }.onAppear {
//            self.loadIngredientsAandAmounts()
//            self.loadUser()
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
