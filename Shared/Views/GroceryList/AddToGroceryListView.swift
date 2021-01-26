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
                    SearchBar(text: self.$groceryListController.amount, isEditing: $isEditingAmount, listIsLoading: $amountListIsLoading, shouldCloseView: $shouldAmountBeOpen, placeHolder: "Amount").onChange(of: groceryListController.amount, perform: { value in
                        searchForAmount()
                    })
                    if !amountList.isEmpty && isEditingAmount {
                        OptionsList(list: amountList, text: self.$groceryListController.amount, isEditing: $isEditingAmount)
                    }
                }.padding(.bottom).zIndex(3)
                
                VStack {
                    SearchBar(text: self.$groceryListController.ingredient, isEditing: $isEditingIngredient, listIsLoading: $ingredientListIsLoading, shouldCloseView: $shouldIngredientBeOpen, placeHolder: "Ingredient").onChange(of: self.groceryListController.ingredient, perform: { value in
                        searchForIngredient()
                    })
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
                    
                    if self.groceryListController.addIngredientToGroceryListMutationRunning {
                        ProgressView()
                    }
                    
                    Button("Add", action: {
                        addIngredientToGroceryList()
                    }).padding().disabled(self.groceryListController.amount.count == 0 || self.groceryListController.ingredient.count == 0 || self.groceryListController.addIngredientToGroceryListMutationRunning)
                    
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
        
        print(amountDB)
        print(ingredientDB)
        
        if amountDB == nil && ingredientDB == nil {
            // if amount & ingredient does not exist, add them to the database
            let mutation = CreateIngredientAndAmountMutation(ingredientName: ingredientString, amountName: amountString)
            
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        print(data)
                        if let createAmount = data.createAmount {
                            let amountFragment = createAmount.fragments.amountFragment
                            amountDB = AmountDemo.object(in: managedObjectContext, withFragment: amountFragment)
                        }
                        if let createIngredient = data.createIngredient {
                            let ingredientFragment = createIngredient.fragments.ingredientFragment
                            ingredientDB = IngredientDemo.object(in: managedObjectContext, withFragment: ingredientFragment)
                        }
                        addIngredientAndAmountToGroceryList()   
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
        }
            
    }
    
    func addIngredientAndAmountToGroceryList() {
        // now we need to add the grocery item to the database

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
                        }.padding(.top, 5)
                        Divider().padding(0)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 300)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)
                
                Spacer()
            }.zIndex(10)
        }
    }
}

struct IngredientOptionsList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var listOfIngredients: FetchRequest<IngredientDemo>
    
    //    var list = [String]()
    @Binding var text: String
    @Binding var isEditing: Bool
    
    init(text: Binding<String>, isEditing: Binding<Bool>) {
        _text = text
        _isEditing = isEditing
        
        listOfIngredients = FetchRequest<IngredientDemo>(
            entity: IngredientDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \IngredientDemo.name, ascending: false)
            ],
            predicate: NSPredicate(format: "name CONTAINS[c] %@", text.wrappedValue))
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
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 300)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)
                
                Spacer()
            }.zIndex(10)
        }
    }
}
