//
//  AddToGroceryListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

struct AddToGroceryListView: View {
    @EnvironmentObject var groceryListController: GroceryListApolloController

    @State var amount = ""
    @State var ingredient = ""
    
    @State var amountList = [String]()
    @State var isEditingAmount = false
    @State var amountListIsLoading = false
    
    @State var ingredientList = [String]()
    @State var isEditingIngredient = false
    @State var ingredientListIsLoading = false
    
    @State var addingIngredientIsLoading = false
    
    func searchForAmount() {
        if isEditingAmount && amount.count > 0 {
            amountListIsLoading = true
            
            let query = SearchForAmountQuery(inputValue: amount)
            
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
        if isEditingIngredient && ingredient.count > 0 {
            ingredientListIsLoading = true
            
            let query = SearchForIngredientQuery(inputValue: ingredient.lowercased())
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
        groceryListController.addIngredientToGroceryList(ingredient: ingredient, amount: amount)
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
                    SearchBar(text: $amount, isEditing: $isEditingAmount, listIsLoading: $amountListIsLoading, placeHolder: "Amount").onChange(of: amount, perform: { value in
                        searchForAmount()
                    })
                    if !amountList.isEmpty && isEditingAmount {
                        OptionsList(list: amountList, text: $amount, isEditing: $isEditingAmount)
                    }
                }.padding(.bottom).zIndex(3)
                
                VStack {
                    SearchBar(text: $ingredient, isEditing: $isEditingIngredient, listIsLoading: $ingredientListIsLoading, placeHolder: "Ingredient").onChange(of: ingredient, perform: { value in
                        searchForIngredient()
                    })
                    if !ingredientList.isEmpty && isEditingIngredient {
                        OptionsList(list: ingredientList, text: $ingredient, isEditing: $isEditingIngredient)
                        
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
                    
                    if addingIngredientIsLoading {
                        ProgressView()
                    }
                    
                    Button("Add", action: {
                        addIngredientToGroceryList()
                    }).padding().disabled(amount.count == 0 || ingredient.count == 0 || addingIngredientIsLoading)
                    
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
