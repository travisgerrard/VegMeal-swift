//
//  AddToGroceryListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI
import CoreData

struct AddToGroceryListView: View {
    @EnvironmentObject var groceryListController: GroceryListApolloController
    
    @State var amountList = [String]()
    @State var isEditingAmount = false
    @State var shouldAmountBeOpen = false
    @State var amountListIsLoading = false
    
    @State var ingredientList = [String]()
    @State var isEditingIngredient = false
    @State var shouldIngredientBeOpen = false
    @State var ingredientListIsLoading = false
    
    func searchForAmount() {
        if isEditingAmount && groceryListController.amount.count > 0 {
            amountListIsLoading = true
            
            let query = SearchForAmountQuery(inputValue: groceryListController.amount)
            
            ApolloController.shared.apollo.fetch(query: query) { result in
                
                amountListIsLoading = false
                
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let allAmounts = data.allAmounts {
                            amountList.removeAll()
                            for amounts in allAmounts {
                                amountList.append(amounts!.name!)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            amountList.removeAll()
        }
    }
    
    func searchForIngredient() {
        if isEditingIngredient && groceryListController.ingredient.count > 0 {
            ingredientListIsLoading = true
            
            let query = SearchForIngredientQuery(inputValue: groceryListController.ingredient.lowercased())
            ApolloController.shared.apollo.fetch(query: query) { result in
                
                ingredientListIsLoading = false
                
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let allIngredients = data.allIngredients {
                            ingredientList.removeAll()
                            for ingredients in allIngredients {
                                ingredientList.append(ingredients!.name!)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            ingredientList.removeAll()
        }
    }
    
    func addIngredientToGroceryList() {
        groceryListController.addIngredientToGroceryList()
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Add To Grocery List")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            
            
            ZStack(alignment: .top) {
                VStack {
                    SearchBar(
                        text: self.$groceryListController.amount,
                        isEditing: $isEditingAmount,
                        listIsLoading: $amountListIsLoading,
                        shouldCloseView: $shouldAmountBeOpen,
                        placeHolder: "Amount")
                        .onChange(
                            of: groceryListController.amount,
                            perform: { value in
                                searchForAmount()
                            }
                        )
                    if !amountList.isEmpty && isEditingAmount {
                        OptionsList(list: amountList, text: self.$groceryListController.amount, isEditing: $isEditingAmount)
                    }
                }.padding(.bottom).zIndex(3)
                
                VStack {
                    SearchBar(
                        text: self.$groceryListController.ingredient,
                        isEditing: $isEditingIngredient,
                        listIsLoading: $ingredientListIsLoading,
                        shouldCloseView: $shouldIngredientBeOpen,
                        placeHolder: "Ingredient")
                        .onChange(
                            of: self.groceryListController.ingredient,
                            perform: { value in
                                searchForIngredient()
                            }
                        )
                    if !ingredientList.isEmpty && isEditingIngredient {
                        OptionsList(list: ingredientList, text: self.$groceryListController.ingredient, isEditing: $isEditingIngredient)
                        
                    }
                    
                    // The following if statement is a hack as it makes textfield more responsive.
                    if isEditingIngredient {
                        Text("")
                    } else {
                        Text("")
                    }
                }.offset(x: 0, y: 50).padding(.bottom).zIndex(2)
                
                HStack{
                    Spacer()
                    
                    if self.groceryListController.aITGLMRunning {
                        ProgressView()
                    }
                    
                    Button("Add", action: {
                        addIngredientToGroceryList()
                    }).padding().disabled(self.groceryListController.amount.count == 0 || self.groceryListController.ingredient.count == 0 || self.groceryListController.aITGLMRunning)
                    
                }.offset(x: 0, y: 100)
            }
            Spacer()
        }
    }
}

struct AddToGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        AddToGroceryListView()
    }
}

