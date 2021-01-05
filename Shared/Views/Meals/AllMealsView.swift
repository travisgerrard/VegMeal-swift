//
//  AllMealsView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/3/21.
//

import SwiftUI

struct AllMealsView: View {
    @Binding var searchTap: Bool
    @Binding  var accountTap: Bool
    @Binding  var blur: Bool
    var ns_search: Namespace.ID
    var ns_grid: Namespace.ID
    let openModal: (_ item: MealFragment, _ fromGrid: Bool) -> ()
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.

    let c = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)
    static let tag: String? = "AllMealsView"

    var body: some View {
        ZStack {
            MealsHeaderView(searchTap: $searchTap, accountTap: $accountTap, blur: $blur, ns_search: ns_search).zIndex(2)
            VStack {
                NavigationView {
                    ScrollView {
                        //Ensure we have a internet connection with data.
                        if self.networkingController.mealsQueryError != nil {
                            Text("There was an error making the request: \(self.networkingController.mealsQueryError?.localizedDescription ?? "Unknown error")").multilineTextAlignment(.center).padding()
                            Spacer()
                        } else {
                            LazyVGrid(columns: [c], spacing: 20) {
                                ForEach(self.networkingController.meals){ item in
                                    MealFragmentView(meal: item)
                                        .onTapGesture(count: 1) { openModal(item, true) }
                                        .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Veggily")
                }.zIndex(1)
            }
        }
        
    }
}

//struct AllMealsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllMealsView()
//    }
//}
