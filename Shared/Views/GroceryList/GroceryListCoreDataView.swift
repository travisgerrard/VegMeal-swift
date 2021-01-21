//
//  GroceryListCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/20/21.
//

import SwiftUI

struct GroceryListCoreDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @AppStorage("userid") var userid = ""
    @AppStorage("isLogged") var isLogged = false

    static let tag: String? = "GroceryListView"

    let groceriesToBuy: FetchRequest<GroceryList>
    let groceriesCompleted: FetchRequest<GroceryList>
    
    init() {
        groceriesToBuy = FetchRequest<GroceryList>(
            entity: GroceryList.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \GroceryList.ingredient?.category, ascending: false)
            ],
            predicate: NSPredicate(format: "isCompleted = %d", false))
        
        groceriesCompleted = FetchRequest<GroceryList>(
            entity: GroceryList.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \GroceryList.dateCompleted, ascending: false)
            ],
            predicate: NSPredicate(format: "isCompleted = %d", true))
    }
    
    
    func loadGroceryList() {
        let query = GetAllGroceryListItemsForUserQuery(id: userid)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            switch result {
            case .failure(let error):
                print(error)
                
                
            case .success(let graphQLResult):
                print("!?!?")
                if let data = graphQLResult.data {
                    if let allGroceryLists = data.allGroceryLists {
                        for groceryItem in allGroceryLists {
                            if let groceryListFragment = groceryItem?.fragments.groceryListFragment {
                                
                                let groceryItemDB = GroceryList.object(in: managedObjectContext, withFragment: groceryListFragment)
                                
                                let groceryListIngredient = IngredientDemo.object(in: managedObjectContext, withFragment: groceryListFragment.ingredient?.fragments.ingredientFragment)
                                
                                let groceryListAmount = AmountDemo.object(in: managedObjectContext, withFragment: groceryListFragment.amount?.fragments.amountFragment)
                                
                                let groceryListMeal = MealDemo.object(in: managedObjectContext, withFragment: groceryListFragment.meal?.fragments.mealDemoFragment)
                                
                                groceryItemDB?.ingredient = groceryListIngredient
                                if let category = groceryItemDB?.ingredient?.category {
                                    groceryItemDB?.category = category
                                }
                                
                                groceryItemDB?.amount = groceryListAmount
                                groceryItemDB?.meal = groceryListMeal
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        if isLogged {
            NavigationView {
                List {
                    // We go through all possible ingredient categories
                    ForEach(0..<11) { index in
                        // If our array of groceries to buy contains a category
                        if groceriesToBuy.wrappedValue.contains(where: {$0.category == index}) {
                            
                            // Make a section headed for category
                            Section(header: Text("\(groceriesToBuy.wrappedValue[0].options[index] ?? "No value")")) {
                            
                                //go thorught all groceres to buy
                                ForEach(groceriesToBuy.wrappedValue) { grocery in
                                    // if the category of grocery == our current caterogy section
                                    if grocery.category == index {
                                        
                                        GroceryListCoreDataCellView(grocery: grocery)
                                    }
                                }
                            }
                            
                        }
                        
                    }
                   
                    
                    Section(header: Text("Completed")) {
                        ForEach(groceriesCompleted.wrappedValue) { grocery in
                            GroceryListCoreDataCellView(grocery: grocery)
                        }
                    }
                }
                .navigationBarTitle("Grocery List")
            }
            
            .onAppear {
                self.loadGroceryList()
            }
        } else {
            LoginInCreateAccountPromt()
        }
    }
}

struct GroceryListCoreDataCellView: View {
    var grocery: GroceryList
    @State var completeIsPressed = false

    var body: some View {
        HStack {
            Button(action: {
            }) {
                Circle()
                    .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                    .frame(width: 32, height: 32)
                    .foregroundColor(grocery.isCompleted ? .gray : .white)
                    .padding(.trailing, 3)
            }
            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                        .onChanged { _ in
                            completeIsPressed = true
                        }
                        .onEnded { _ in
                            // What to do when complete button is pressed
                            completeIsPressed = false
                        }
            )
            
            VStack(alignment: .leading) {
                Text("\(grocery.groceryIngredientName) - \(grocery.groceryAmountName)")
                if grocery.isCompleted && grocery.dateCompleted != nil {
                    Text("Completed \(grocery.dateCompleted!, style: .relative) ago").font(.caption)
                } else if grocery.isCompleted {
                    Text("Completed just now").font(.caption)
                }
                if grocery.meal?.mealName != nil {
                    Text("\((grocery.meal?.mealName)!)").font(.footnote).italic()
                }
            }.foregroundColor(grocery.isCompleted ? .gray : .black)
            
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
            .gesture(TapGesture()
                        .onEnded {
                            // What happens when you tap trash button
                            
                        }
            )
            
        }
    }
}

//struct GroceryListCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroceryListCoreDataView()
//    }
//}
