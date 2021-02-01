//
//  SearchView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 10/6/20.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    @EnvironmentObject var searchMealController: SearchMealApolloController     //Get the networking controller from the environment objects.

    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""

    @Namespace private var ns_grid // ids to match grid elements with modal

    
    @Binding var shouldCloseView: Bool
    @State var isEditing: Bool = false
    
    @State private var shake = false
    @State private var blur: Bool = false
    
    // Tap flags
    @State var mealDoubleTap: String? = nil
    @State private var mealTap: String? = nil
    @State private var mealIndex: Int? = nil
    @State private var favoriteTap: String? = nil
    @State private var searchTap: Bool = false
    
    // Views are matched at insertion, but onAppear we broke the match
    // in order to animate immediately after view insertion
    // These flags control the match/unmatch
    @State private var flyFromGridToFavorite: Bool = false
    @State private var flyFromGridToModal: Bool = false
    @State var flyFromFavoriteToModal: Bool = false
    
    // Determine if geometry matches occur
    var matchGridToModal: Bool { !flyFromGridToModal && mealTap != nil }
    var matchFavoriteToModal: Bool { !flyFromGridToModal && favoriteTap != nil }
    func matchGridToFavorite(_ id: String) -> Bool { mealDoubleTap == id && !flyFromGridToFavorite }
    let c = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)

    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    SearchBar(
                        text: self.$searchMealController.searchText,
                        isEditing: self.$isEditing,
                        listIsLoading: self.$searchMealController.searchQueryIsLoading,
                        shouldCloseView: self.$shouldCloseView,
                        placeHolder: "Search for meal"
                    )
                }.padding(.top)
                ScrollView {
                    if self.searchMealController.searchMealList.isEmpty {
                        if self.searchMealController.searchText == "" {
                            Text("Enter text in the search box to find a meal")
                                .foregroundColor(.secondary).padding()
                        } else {
                            Text("No meals were found for \(self.searchMealController.searchText)")
                                .foregroundColor(.secondary).padding()
                        }
                       
                    } else {
                        LazyVGrid(columns: [c], spacing: 20) {
                            ForEach(self.searchMealController.searchMealList){ item in
                                MealFragmentView(meal: item)
                                    .onTapGesture(count: 1) {
                                        hideKeyboard()
                                        openModal(item, fromGrid: true)
                                    }
                                    .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                            }
                        }
                    }

                }
            }
            .toolbar {
                
            }
            .zIndex(11)
            
            //-------------------------------------------------------
            // Backdrop blurred view (zIndex = 3)
            //-------------------------------------------------------
            BlurViewTwo(active: blur, onTap: dismissModal)
                .zIndex(13)
            
            //-------------------------------------------------------
            // Modal View (zIndex = 4)
            //-------------------------------------------------------
            if mealTap != nil && mealIndex != nil || favoriteTap != nil {
//                 ModalView(
//                    id: mealTap ?? favoriteTap!,
//                    meal: self.$networkingController.meals[mealIndex!],
//                    pct: flyFromGridToModal ? 1 : 0,
//                    flyingFromGrid: mealTap != nil,
//                    userId: isLogged ? userid : nil,
//                    onClose: dismissModal)
//                    .matchedGeometryEffect(id: matchGridToModal ? mealTap! : "0", in: ns_grid, isSource: false)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
//                    .onDisappear { flyFromGridToModal = false }
//                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
//                    .zIndex(14)
            }
        }

    }
    
    func dismissModal() {
        withAnimation(.basic) {
            mealTap = nil
            mealIndex = nil
            favoriteTap = nil
            blur = false
        }
    }
    
    func openModal(_ item: MealFragment, fromGrid: Bool) {

        if fromGrid {
            mealTap = item.id
            mealIndex = self.networkingController.meals.firstIndex(where: {$0.id == item.id})
        } else {
            favoriteTap = item.id
        }
        
        withAnimation(.basic) {
            blur = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(shouldCloseView: .constant(false))
    }
}
