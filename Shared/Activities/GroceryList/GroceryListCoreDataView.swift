//
//  GroceryListCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/20/21.
//

import SwiftUI

struct GroceryListCoreDataView: View {
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false

    static let tag: String? = "GroceryListView"
    
    let groceriesToBuy: FetchRequest<GroceryList>
    let groceriesCompleted: FetchRequest<GroceryList>

    @State var isAddingGrocery = false

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

    var groceryList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                // Create a section with the add grocery list view...
                // We go through all possible ingredient categories
                ForEach(0..<11) { index in
//                     If our array of groceries to buy contains a category we should show, otherwise note show
                    if groceriesToBuy.wrappedValue.contains(where: {$0.category == index}) {
                        // Make a section headed for category
                    Section(header: SectionHeaderView(headerViewTitle: "\(groceriesToBuy.wrappedValue[0].options[index] ?? "No value")")
//                            header: Text("\(groceriesToBuy.wrappedValue[0].options[index] ?? "No value")")
                        ) {
                            // go through all groceries to buy
                            ForEach(groceriesToBuy.wrappedValue) { grocery in
                                // if the category of grocery == our current category section
                                if grocery.category == index {
                                    GroceryListCoreDataCellView(grocery: grocery)
                                }
                            }
                        }
                    }
                }

                Section(header: SectionHeaderView(headerViewTitle: "Completed")) {
                    ForEach(groceriesCompleted.wrappedValue) { grocery in
                        GroceryListCoreDataCellView(grocery: grocery)
                    }
                }
            }
//            .navigationBarTitle("Grocery List", displayMode: .inline)
            .navigationBarTitle("Grocery List", displayMode: isAddingGrocery ? .inline : .automatic)
            .navigationBarItems(
                trailing:
                    Button {
                        // Add item to list...
                        withAnimation {
                            isAddingGrocery.toggle()
                        }
                    } label: {
                        Image(systemName: isAddingGrocery ? "minus" : "plus")
                    }
            )
            .listStyle(PlainListStyle())
        }

    }

    var body: some View {
        if isLogged {
            NavigationView {
                VStack {
                    if isAddingGrocery {
                        AddToGroceryListCoreDataView()
                            .fixedSize(horizontal: false, vertical: true)
                            .animation(.easeIn)
                    }
                    groceryList
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())

        } else {
            LoginInCreateAccountPromt()
        }
    }
}

struct AddNewItemToGroceryList: View {
    @Binding var showAddItemToGroceryListView: Bool

    var body: some View {
        Button {
            // Add item to list...
            showAddItemToGroceryListView.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
}

 struct GroceryListCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListCoreDataView()
    }
 }
