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
    
    @State var isShowingAddItemToGroceryList: Bool = false
    
    @State var showCard = false
    @State var show = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    
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
            ZStack {
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
                    .navigationBarItems(trailing: Button(action: {
                        // Add item to list...
                        bottomState.height += -600
                        showFull = true
                        
                    }) {
                        Image(systemName: "plus")
                    })
                    .listStyle(PlainListStyle())
                }
                .onAppear {
                    self.loadGroceryList()
                }
                
                GeometryReader { bounds in
                    BottomCardView(show: $showCard, bottomState: $bottomState)
                        .offset(x: 0, y: showCard ? bounds.size.height / 2 :
                                    bounds.size.height)
                        .offset(y: bottomState.height)
                        .blur(radius: show ? 20 : 0)
                        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                        .gesture(DragGesture().onChanged { value in
                            bottomState = value.translation
                            if showFull {
                                bottomState.height += -600
                            }
                            //                            if bottomState.height < -500 {
                            //                                bottomState.height = -500
                            //                            }
                        }
                        .onEnded{ value in
                            if bottomState.height > 50 {
                                showCard = false
                            }
                            if (bottomState.height < -100 && !showFull) || (bottomState.height < -400 && showFull) {
                                bottomState.height = -600
                                showFull = true
                            } else {
                                showFull = false
                                hideKeyboard()
                                bottomState = .zero
                            }
                        }
                        )
                }
            }
            
        } else {
            LoginInCreateAccountPromt()
        }
    }
}

struct AddNewItemToGroceryList: View {
    @Binding var showAddItemToGroceryListView: Bool
    
    var body: some View {
        Button(action: {
            // Add item to list...
            showAddItemToGroceryListView.toggle()
        }) {
            Image(systemName: "plus")
        }
    }
}

struct BottomCardView: View {
    @Binding var show: Bool
    @Binding var bottomState: CGSize
    
    var body: some View {
        
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3.0)
                .opacity(0.1)
            AddToGroceryListCoreDataView()
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
        .frame(maxWidth: 712)
        .frame(height: 750)
        .background(BlurView(style: .systemThinMaterial))
        .cornerRadius(30)
        .shadow(radius: 20)
        .frame(maxWidth: .infinity)
        
    }
}

struct GroceryListCoreDataCellView: View {
    var grocery: GroceryList
    @State var completeIsPressed = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func toggleGroceryComplete(grocery: GroceryList) {
        grocery.isCompleted = !grocery.isCompleted
        
        let today = Date()
        
        grocery.dateCompleted = today
        
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formatter3 = iso8601DateFormatter.string(from: today)
        
        let mutation = CompleteGroceryListMutation(id: grocery.idString, dateCompleted: formatter3, isCompleted: grocery.isCompleted)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
            // Need to undo recent core data cahnges
            // Perhaps this takes picture or resetting contexts, then showing alert.
            
            case .success(let graphQLResults):
                print("success: \(graphQLResults)")
            // Don't need to do anything as coredata as local core data already reflects
            // Perhaps this would be a good place to save the context
            }
            
        }
    }
    
    func removeItemFromGroceryList(grocery: GroceryList) {
        let mutation = DeleteGroceryListItemMutation(id: grocery.idString)
        
        managedObjectContext.delete(grocery)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                try? managedObjectContext.save()
            }
        }
    }
    
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
                            toggleGroceryComplete(grocery: grocery)
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
                            removeItemFromGroceryList(grocery: grocery)
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
