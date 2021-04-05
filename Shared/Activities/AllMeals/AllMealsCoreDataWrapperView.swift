//
//  AllMealsCoreDataWrapperView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import SwiftUI

struct AllMealsCoreDataWrapperView: View {
    static let tag: String? = "AllMealsView"
    @State private var showAddMealModal: Bool = false
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false

    var searchButton: some View {
        NavigationLink(destination: SearchCoreDataView(), label: {
            Image(systemName: "magnifyingglass")
                .padding(.trailing)
        })
    }

    var addNewMealButton: some View {
        Button(
            action: {showAddMealModal = true},
            label: { Image(systemName: "rectangle.stack.badge.plus") }
        )
        .sheet(isPresented: $showAddMealModal) {
            AddMealView(showModal: self.$showAddMealModal)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                AllMealsCoreDataView()
            }
            .navigationBarTitle("Veggily")
            .navigationBarItems(
                leading: AccountButton(),
                trailing:
                    HStack {
                        searchButton
                        if isLogged {
                            addNewMealButton
                        }
                    }
            )
        }
        .navigationViewStyle(
            StackNavigationViewStyle()
        )
        
    }
}

struct AllMealsCoreDataWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        AllMealsCoreDataWrapperView()
            .environmentObject(UserApolloController())
    }
}
