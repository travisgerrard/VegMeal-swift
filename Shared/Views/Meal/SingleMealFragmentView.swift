//
//  MealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SingleMealFragmentView: View {
    //MARK: Properties
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var networkingController: ApolloNetworkingController

    let namespace: Namespace.ID
    @Binding var showIndavidualMeal: Bool
    @Binding var isDisabled: Bool
    
    //MARK: Functions
        func parse(object: MealFragment) -> URL {
            guard let mealImage = object.mealImage?.publicUrlTransformed else { return URL(string: "")! }
            
            return URL(string: mealImage)!
        }
    
    var body: some View {
        ZStack {
            Color
                .white
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    HStack {
                        WebImage(url: self.parse(object: self.networkingController.meal!))
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        
                        
                        Divider().background(Color.black)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(self.networkingController.meal!.name ?? "No name")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.5)
                            
                            Text(self.networkingController.meal!.description ?? "No Description")
                                .font(.subheadline)
                            Spacer()
                            
                            if(user.isLogged){
                                Button("Add To Grocery List", action: {
                                    self.networkingController.addMealToGroceryList(mealId: self.networkingController.meal!.id!, userId: user.userid)
                                }).font(.callout)
                                if self.networkingController.addingMealToGroceryListIsLoading {
                                    ProgressView()
                                }
                                
                            }
                            
                        }
                        
                        
                        Spacer()
                        VStack {
                            CloseButton()
                                .padding(16)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                                        showIndavidualMeal.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            isDisabled = false
                                        }
                                    }
                                }
                                .zIndex(2)
                                .offset(x: 2, y: -30)
                            Spacer()
                            if (user.isLogged && user.userid == self.networkingController.meal!.author!.id){
                                Button("Edit", action: {}).font(.callout)
                            }
                            
                        }
                        
                    }
                    .matchedGeometryEffect(id: "\(self.networkingController.meal!.id ?? "")Photo", in: namespace, isSource: showIndavidualMeal)
                    .frame(height: 200)
                    
                    Divider().background(Color.black).padding(.horizontal)
                    
                    
                    HStack {
                        Text("Ingredients")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                    }
                
                    ListOfIngredients(mealId: self.networkingController.meal!.id ?? "")
                    
                    if (user.isLogged && user.userid == self.networkingController.meal!.author!.id){
                    AddIngredients(mealId: self.networkingController.meal!.id ?? "").padding(.bottom, 100)
                    }
                    
                    if user.isLogged {
                        Divider().background(Color.black)
                        MealLogView(mealId: self.networkingController.meal!.id!, authorId: user.userid)
                    }
                    
                }
            }
            .background(Color("background1"))
        }
    }
}

struct AddIngredients: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController
    var mealId: String
    
    @State var amountList = [String]()
    @State var isEditingAmount = false
    @State var amountListIsLoading = false
    
    @State var ingredientList = [String]()
    @State var isEditingIngredient = false
    @State var ingredientListIsLoading = false
    
    func searchForAmount() {
        if isEditingAmount && self.networkingController.amount.count > 0 {
            amountListIsLoading = true
            
            let query = SearchForAmountQuery(inputValue: self.networkingController.amount)
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
        if isEditingIngredient && self.networkingController.ingredient.count > 0 {
            ingredientListIsLoading = true
            
            ApolloController.shared.apollo.fetch(query: SearchForIngredientQuery(inputValue: self.networkingController.ingredient.lowercased())) { result in
                
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
                    SearchBar(text: self.$networkingController.amount, isEditing: $isEditingAmount, listIsLoading: $amountListIsLoading, placeHolder: "Amount").onChange(of: self.networkingController.amount, perform: { value in
                        searchForAmount()
                    })
                    if !amountList.isEmpty && isEditingAmount {
                        OptionsList(list: amountList, text: self.$networkingController.amount, isEditing: $isEditingAmount)
                    }
                }.padding(.bottom).zIndex(3)
                
                
                VStack {
                    SearchBar(text: self.$networkingController.ingredient, isEditing: $isEditingIngredient, listIsLoading: $ingredientListIsLoading, placeHolder: "Ingredient").onChange(of: self.networkingController.ingredient, perform: { value in
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
                        createMealIngredientList()
                    }).padding().disabled(self.networkingController.amount.count == 0 || self.networkingController.ingredient.count == 0 || self.networkingController.addingIngredientIsLoading)
                    
                }.offset(x: 0, y: 100)
            }
            
        }
        
        
        
        
    }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var listIsLoading: Bool
    var placeHolder: String
    
    
    var body: some View {
        VStack {
            HStack {
                
                TextField(placeHolder, text: $text, onEditingChanged: { edit in
                    if edit {
                        self.isEditing = true
                    } else {
                        self.isEditing = false
                    }
                },
                onCommit: {
                    self.isEditing = false
                })
                .padding(.horizontal, 32)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if listIsLoading {
                            ProgressView().padding(.trailing, 8)
                        }
                        
                        if self.isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                
                
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        // Dismiss the keyboard
                        hideKeyboard()
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            Divider().background(Color.black).padding(.horizontal)
        }
    }
}

struct OptionsList: View {
    var list = [String]()
    @Binding var text: String
    @Binding var isEditing: Bool
    
    
    var body: some View {
        ScrollView {
            ForEach(list, id: \.self) { string in
                HStack {
                    Text(string).padding(.leading)
                    Spacer()
                }.onTapGesture(count:1) {
                    text = string
                    isEditing = false
                    hideKeyboard()
                }
                Divider()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        .padding(.horizontal, 5)
        .zIndex(10)
    }
}

struct ListOfIngredients: View {
    @EnvironmentObject var user: UserStore

    @EnvironmentObject var networkingController: ApolloNetworkingController
    var mealId: String

    var body: some View {
        VStack {
            if self.networkingController.meal!.ingredientList.count > 0 {
                ForEach(self.networkingController.meal!.ingredientList) { ingredient in
                    HStack(spacing: 1) {
                        Text("\(ingredient.amount?.name ?? "No amount") - \(ingredient.ingredient?.name ?? "No ingredient")")
                            .padding()
                        Spacer()
                        if (user.isLogged && user.userid == self.networkingController.meal!.author!.id){

                        Button(action: {
                            self.networkingController.deleteMealIngredientList(mealIngredientListId: ingredient.id!, ingredientId: ingredient.ingredient!.id!, mealId: mealId)
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
                HStack {
                    Text("No ingredients added for this meal").padding()
                    Spacer()
                }
            }
        }
    }
}
