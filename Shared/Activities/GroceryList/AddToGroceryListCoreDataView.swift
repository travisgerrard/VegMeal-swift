//
//  AddToGroceryListCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/27/21.
//

import SwiftUI
import CoreData

struct AddToGroceryListCoreDataView: View {
    @EnvironmentObject var dataController: DataController

    @State var isEditingAmount = false
    @State var shouldAmountBeOpen = false
    @State var amountListIsLoading = false
    @State var amountString = ""

    @State var isEditingIngredient = false
    @State var shouldIngredientBeOpen = false
    @State var ingredientListIsLoading = false
    @State var ingredientString = ""

    var meal: MealDemo?

    @AppStorage("userid", store: UserDefaults.shared) var userid = ""

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Add To Grocery List")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding([.horizontal, .top])
                    Spacer()
                }
            }
            VStack {
                VStack {
                        SearchBar(
                            text: $amountString,
                            isEditing: $isEditingAmount,
                            listIsLoading: $amountListIsLoading,
                            shouldCloseView: $shouldAmountBeOpen,
                            placeHolder: "Amount"
                        )
                    if isEditingAmount {
                            AmountOptionsList(
                                text: $amountString,
                                isEditing: $isEditingAmount
                            )

                    }
                }.padding(.bottom)
                
                VStack {
                    SearchBar(
                        text: $ingredientString,
                        isEditing: $isEditingIngredient,
                        listIsLoading: $ingredientListIsLoading,
                        shouldCloseView: $shouldIngredientBeOpen,
                        placeHolder: "Ingredient"
                    )
                    if isEditingIngredient {
                        IngredientOptionsList(text: $ingredientString, isEditing: $isEditingIngredient)
                    }
                    // The following if statement is a hack as it makes textfield more responsive.
                    if isEditingIngredient {
                        Text("")
                    } else {
                        Text("")
                    }
                }

                HStack {
                    Spacer()
                    Button("Add", action: {
                        isEditingAmount = false
                        isEditingIngredient = false
                        dataController.addIngredientToGroceryList(
                            amountToLookFor: amountString,
                            ingredientToLookFor: ingredientString,
                            addToMeal: meal)
                    })
                    .padding(.horizontal)
                    .disabled(amountString.count == 0 || ingredientString.count == 0)
                }
            }
        }
    }
}

struct AddToGroceryListCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddToGroceryListCoreDataView()
    }
}

struct AmountOptionsList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var listOfAmounts: FetchRequest<AmountDemo>
    
    @Binding var text: String
    @Binding var isEditing: Bool

    @State var frameSizeHeight: CGFloat = 0
    
    init(text: Binding<String>, isEditing: Binding<Bool>) {
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
                        }.onTapGesture(count: 1) {
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
                .frame(height: frameSizeHeight > 250 ? 250 : frameSizeHeight)
                .frame(maxWidth: .infinity)
                
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)
                .animation(.easeIn)
            }
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
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
                        }.onTapGesture(count: 1) {
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
                .frame(height: frameSizeHeight > 250 ? 250 : frameSizeHeight)
                .frame(maxWidth: .infinity)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .padding(.horizontal, 5)

            }.zIndex(10)
        }
    }
}
