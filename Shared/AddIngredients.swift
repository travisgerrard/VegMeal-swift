//
//  AddIngredients.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/30/20.
//

import SwiftUI

struct AddIngredients: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController

    var mealId: String

    @State var amountList = [String]()
    @State var isEditingAmount = false
    @State var shouldAmountBeOpen = false
    @State var amountListIsLoading = false

    @State var ingredientList = [String]()
    @State var isEditingIngredient = false
    @State var shouldIngredientBeOpen = false
    @State var ingredientListIsLoading = false
    
    func searchForAmount() {
        if isEditingAmount && self.networkingController.amount.count > 0{
            amountListIsLoading = true

            let query = SearchForAmountQuery(inputValue: self.networkingController.amount)
            ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in

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
        if isEditingIngredient && self.networkingController.ingredient.count > 0 {
            ingredientListIsLoading = true

            let query = SearchForIngredientQuery(inputValue: self.networkingController.ingredient.lowercased())
            ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in

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
    
    func createMealIngredientList() {
//        print(self.networkingController.amount.count)
//        print(self.networkingController.ingredient.count)
        if self.networkingController.amount.count > 0 && self.networkingController.ingredient.count > 0 {
            self.networkingController.createMealIngredientList(mealId: mealId)
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Add Ingredients")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }.padding(.top)

            ZStack(alignment: .top) {
                VStack {
                    SearchBar(text: self.$networkingController.amount, isEditing: $isEditingAmount, listIsLoading: $amountListIsLoading, shouldCloseView: $shouldAmountBeOpen, placeHolder: "Amount").onChange(of: self.networkingController.amount, perform: { value in
                        searchForAmount()
                    })
                    if !amountList.isEmpty && isEditingAmount {
                        OptionsList(list: amountList, text: self.$networkingController.amount, isEditing: $isEditingAmount)
                                .frame(maxWidth: .infinity, maxHeight: 300)

                    }
                }.padding(.bottom).zIndex(3)


                VStack {
                    SearchBar(text: self.$networkingController.ingredient, isEditing: $isEditingIngredient, listIsLoading: $ingredientListIsLoading, shouldCloseView: $shouldIngredientBeOpen, placeHolder: "Ingredient").onChange(of: self.networkingController.ingredient, perform: { value in
                        searchForIngredient()
                    })
                    if !ingredientList.isEmpty && isEditingIngredient {
                        OptionsList(list: ingredientList, text: self.$networkingController.ingredient, isEditing: $isEditingIngredient)

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
                    
                    if self.networkingController.addingIngredientIsLoading {
                        ProgressView()
                    }
                    
                    Button("Add", action: {
                        withAnimation(.spring()) {
                            createMealIngredientList()
                        }
                    }).padding().disabled(self.networkingController.amount.count == 0 || self.networkingController.ingredient.count == 0 || self.networkingController.addingIngredientIsLoading)
                    
                }.offset(x: 0, y: 100)
            }
            Spacer()
        }.frame(maxWidth: .infinity).frame(height: 550)
        
    }
}

struct AddIngredients_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredients(mealId: "5f4c7bfdf818ca3c74eb7d6d")
            .environmentObject(ApolloNetworkingController())
    }
}
