//
//  SearchCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/23/21.
//

import SwiftUI

struct SearchCoreDataView: View {
    @State var text = ""
    @State private var isEditing = false
    
    var body: some View {

        ScrollView {
                HStack {
                    TextField("Search ...", text: $text)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.isEditing = true
                        }
                    
                    if isEditing {
                        Button(action: {
                            self.isEditing = false
                            self.text = ""
                            
                        }) {
                            Text("Cancel")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                }
                if (text != "") {
                    SearchMealsCoreDataView(text: text)

                }
        }

        .navigationBarTitle("Search")
    }
}

struct SearchMealsCoreDataView: View {
    
    let text: String
    let mealSearch: FetchRequest<MealDemo>

    @Environment(\.managedObjectContext) var managedObjectContext
    let columnSpacing = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)
    
    init(text: String) {
        self.text = text
        
        mealSearch = FetchRequest<MealDemo>(
            entity: MealDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MealDemo.name, ascending: false)
            ],
            predicate: NSPredicate(format: "name CONTAINS[c] %@", text))
    }
    
    
    
    var body: some View {
            LazyVGrid(columns: [columnSpacing], spacing: 20) {
                ForEach(mealSearch.wrappedValue) { meal in
                    NavigationLink(
                        destination: MealCoreDataView(meal: meal),
                        label: {
                            MealFragmentCoreDataView(meal: meal)
                        })
                }.listRowInsets(EdgeInsets())
            }
        }
}

//struct SearchCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchCoreDataView()
//    }
//}
