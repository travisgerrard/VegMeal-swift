//
//  AddToGroceryListCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/27/21.
//

import SwiftUI
import CoreData

struct AddToGroceryListCoreDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var isEditingAmount = false
    @State var shouldAmountBeOpen = false
    @State var amountListIsLoading = false
    @State var amountString = ""
    @State var amountDB: AmountDemo?
    
    @State var isEditingIngredient = false
    @State var shouldIngredientBeOpen = false
    @State var ingredientListIsLoading = false
    @State var ingredientString = ""
    @State var ingredientDB: IngredientDemo?
    
    var meal: MealDemo? = nil
    
    @AppStorage("userid") var userid = ""
    
    func addIngredientToGroceryList() {
        // Find out if amounts / ingredient at already in the database
        let amountNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AmountDemo")
        amountNameFetch.predicate = NSPredicate(format: "name == %@", amountString)
        
        do {
            let fetchedAmountByName = try managedObjectContext.fetch(amountNameFetch) as! [AmountDemo]
            if fetchedAmountByName.count > 0 {
                amountDB = fetchedAmountByName[0]
            }
        } catch {
            fatalError("Failed to amounts: \(error)")
        }
        
        let ingredientNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientDemo")
        ingredientNameFetch.predicate = NSPredicate(format: "name == %@", ingredientString)
        
        do {
            let fetchedIngredientByName = try managedObjectContext.fetch(ingredientNameFetch) as! [IngredientDemo]
            if fetchedIngredientByName.count > 0 {
                ingredientDB = fetchedIngredientByName[0]
            }
        } catch {
            fatalError("Failed to amounts: \(error)")
        }
        
        if amountDB == nil && ingredientDB == nil {
            // if amount & ingredient does not exist, add them to the database
            let mutation = CreateIngredientAndAmountMutation(ingredientName: ingredientString, amountName: amountString)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    print ("Success: \(graphQLResult)")
                    if let data = graphQLResult.data {
                        //                        print(data)
                        if let createAmount = data.createAmount {
                            let amountFragment = createAmount.fragments.amountFragment
                            amountDB = AmountDemo.object(in: managedObjectContext, withFragment: amountFragment)
                            if let createIngredient = data.createIngredient {
                                let ingredientFragment = createIngredient.fragments.ingredientFragment
                                ingredientDB = IngredientDemo.object(in: managedObjectContext, withFragment: ingredientFragment)
                                addIngredientAndAmountToGroceryList()
                                
                            }
                        }
                        
                    }
                }
            }
        } else if amountDB == nil && ingredientDB != nil {
            // add amount to database
            let mutation = CreateAmountMutation(name: amountString)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createAmount = data.createAmount {
                            let amountFragment = createAmount.fragments.amountFragment
                            amountDB = AmountDemo.object(in: managedObjectContext, withFragment: amountFragment)
                            addIngredientAndAmountToGroceryList()
                        }
                    }
                }
            }
        } else if amountDB != nil && ingredientDB == nil {
            // add ingredient to the database
            let mutation = CreateIngredientMutation(name: ingredientString)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createIngredient = data.createIngredient {
                            let ingredientFragment = createIngredient.fragments.ingredientFragment
                            ingredientDB = IngredientDemo.object(in: managedObjectContext, withFragment: ingredientFragment)
                            addIngredientAndAmountToGroceryList()
                        }
                    }
                }
            }
        } else if amountDB != nil && ingredientDB != nil {
            addIngredientAndAmountToGroceryList()
        }
        
    }
    
    func addIngredientAndAmountToGroceryList() {
        // now we need to add the grocery item to the database
        
        
        if meal != nil {
            let mutation = CreateMealIngredientListMutation(mealId: meal!.idString, ingredientId: ingredientDB!.idString, amountId: amountDB!.idString)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createMealIngredientList = data.createMealIngredientList {
                            let mealIngredientListFragment = createMealIngredientList.fragments.mealIngredientListFragment
                            
                            let mealIngredientListDB = MealIngredientListDemo.object(in: managedObjectContext, withFragment: mealIngredientListFragment)
                            
                            mealIngredientListDB?.amountDemo = amountDB
                            mealIngredientListDB?.ingredientDemo = ingredientDB
                            
                            meal?.mutableSetValue(forKey: "mealIngredientListDemo").add(mealIngredientListDB!)
                            
                            try? managedObjectContext.save()

                            // Reset vars after adding
                            
                            amountDB = nil
                            ingredientDB = nil
                            amountString = ""
                            ingredientString = ""
                        }
                        
                    }
                }
            }
        } else {
            let mutation = CreateGrocerylistItemMutation(ingredientId: ingredientDB!.idString, amountId: amountDB!.idString, userId: userid)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createGroceryList = data.createGroceryList {
                            let groceryListFragment = createGroceryList.fragments.groceryListFragment
                            
                            let groceryListDB = GroceryList.object(in: managedObjectContext, withFragment: groceryListFragment)
                            
                            groceryListDB?.amount = amountDB
                            groceryListDB?.ingredient = ingredientDB
                            
                            try? managedObjectContext.save()
                            
                            // Reset vars after adding
                            amountDB = nil
                            ingredientDB = nil
                            amountString = ""
                            ingredientString = ""
                        }
                    }
                }
            }
        }
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
                    SearchBar(text: $amountString, isEditing: $isEditingAmount, listIsLoading: $amountListIsLoading, shouldCloseView: $shouldAmountBeOpen, placeHolder: "Amount")
                    if isEditingAmount {
                        AmountOptionsList(text: $amountString, isEditing: $isEditingAmount, amountDB: $amountDB)
                    }
                }.padding(.bottom).zIndex(3)
                
                VStack {
                    SearchBar(text: $ingredientString, isEditing: $isEditingIngredient, listIsLoading: $ingredientListIsLoading, shouldCloseView: $shouldIngredientBeOpen, placeHolder: "Ingredient")
                    if isEditingIngredient {
                        IngredientOptionsList(text: $ingredientString, isEditing: $isEditingIngredient)
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
                    Button("Add", action: {
                        isEditingAmount = false
                        isEditingIngredient = false
                        addIngredientToGroceryList()
                    }).padding().disabled(amountString.count == 0 || ingredientString.count == 0)
                    
                }.offset(x: 0, y: 100)
            }
            Spacer()
        }
    }
}

struct AmountOptionsList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var listOfAmounts: FetchRequest<AmountDemo>
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    @State var frameSizeHeight: CGFloat = 0
    
    init(text: Binding<String>, isEditing: Binding<Bool>, amountDB: Binding<AmountDemo?>) {
        _text = text
        _isEditing = isEditing
        
        listOfAmounts = FetchRequest<AmountDemo>(
            entity: AmountDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \AmountDemo.name, ascending: true)
            ],
            predicate: NSPredicate(format: "name BEGINSWITH %@", text.wrappedValue))
        
        print(text.wrappedValue)
    }
    
    
    var body: some View {
        if !listOfAmounts.wrappedValue.isEmpty {
            VStack {
                ScrollView {
                    ForEach(listOfAmounts.wrappedValue) { amount in
                        HStack {
                            Text(amount.amountName).padding(.leading)
                            Spacer()
                        }.onTapGesture(count:1) {
                            text = amount.amountName
                            isEditing = false
                            hideKeyboard()
                        }.padding(.top, 8)
                        Divider().padding(0)
                    }.background(GeometryReader {
                                    // calculate height by consumed background and store in
                                    // view preference
                                    Color.clear.preference(key: ViewHeightKey.self,
                                                           value: $0.frame(in: .local).size.height) })
                }
                .onPreferenceChange(ViewHeightKey.self) {
                    frameSizeHeight = $0
                }
                .frame(height: frameSizeHeight > 300 ? 300 : frameSizeHeight)
                .frame(maxWidth: .infinity)
                
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)
                
                
                
                Spacer()
            }.zIndex(10)
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct IngredientOptionsList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var listOfIngredients: FetchRequest<IngredientDemo>
    
    //    var list = [String]()
    @Binding var text: String
    @Binding var isEditing: Bool
    
    @State var frameSizeHeight: CGFloat = 0
    
    
    init(text: Binding<String>, isEditing: Binding<Bool>) {
        _text = text
        _isEditing = isEditing
        
        listOfIngredients = FetchRequest<IngredientDemo>(
            entity: IngredientDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \IngredientDemo.name, ascending: false)
            ],
            predicate: NSPredicate(format: "name BEGINSWITH[c] %@", text.wrappedValue))
    }
    
    
    var body: some View {
        if !listOfIngredients.wrappedValue.isEmpty {
            
            VStack {
                ScrollView {
                    ForEach(listOfIngredients.wrappedValue) { ingredient in
                        HStack {
                            Text(ingredient.ingredientName).padding(.leading)
                            Spacer()
                        }.onTapGesture(count:1) {
                            text = ingredient.ingredientName
                            isEditing = false
                            hideKeyboard()
                        }.padding(.top, 5)
                        Divider().padding(0)
                    }.background(
                        // This lets us dynamically change scrollview hieght to size of content
                        GeometryReader {
                            // calculate height by consumed background and store in
                            // view preference
                            Color.clear.preference(key: ViewHeightKey.self,
                                                   value: $0.frame(in: .local).size.height) })
                }
                .onPreferenceChange(ViewHeightKey.self) {
                    // when size of ForEach loop above changes, changes height of scrollview!
                    frameSizeHeight = $0
                }
                .frame(height: frameSizeHeight > 300 ? 300 : frameSizeHeight)
                .frame(maxWidth: .infinity)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)
                
                Spacer()
            }.zIndex(10)
        }
    }
}
