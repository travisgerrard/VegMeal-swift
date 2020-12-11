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

    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""

    @Namespace private var ns_grid // ids to match grid elements with modal

    @State var searchMealList = [MealFragment]()
    @State var searchText = ""
    @Binding var shouldCloseView: Bool
    @State var isEditing: Bool = false
    @State var searchQueryIsLoading: Bool = false
    
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

    func searchForMeal() {
        if isEditing && searchText.count > 0 {
            searchQueryIsLoading = true

            let query = SearchForMealsQuery(searchText: searchText)
            
            ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in

                searchQueryIsLoading = false

                switch result {
                case .success(let graphQLResult):
                    
                    if let data = graphQLResult.data {
                        if let allMeals = data.allMeals {
                           
                            searchMealList.removeAll()
                            for meal in allMeals {
                                searchMealList.append(meal!.fragments.mealFragment)
                            }
                        }
                    }

                case .failure(let error):
                    print(error)
                }
            }
            
        } else {
            searchMealList.removeAll()
        }
    }
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    SearchBar(text: $searchText, isEditing: $isEditing, listIsLoading: $searchQueryIsLoading, shouldCloseView: $shouldCloseView, placeHolder: "Search for meal")
                        .onChange(of: searchText, perform: { value in
                            searchForMeal()
                        }).background(Color.white)
                }
                ScrollView {
                    LazyVGrid(columns: [c], spacing: 20) {
                        ForEach(searchMealList){ item in
                            MealFragmentView(meal: item)
                                .onTapGesture(count: 1) {
                                    hideKeyboard()
                                    openModal(item, fromGrid: true)
                                }
                                .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                        }
                    }
                }
                Spacer()
            }
            
            //-------------------------------------------------------
            // Backdrop blurred view (zIndex = 3)
            //-------------------------------------------------------
            BlurViewTwo(active: blur, onTap: dismissModal)
                .zIndex(3)
            
            //-------------------------------------------------------
            // Modal View (zIndex = 4)
            //-------------------------------------------------------
            if mealTap != nil && mealIndex != nil || favoriteTap != nil {
                ModalView(
                    id: mealTap ?? favoriteTap!,
                    meal: self.$networkingController.meals[mealIndex!],
                    pct: flyFromGridToModal ? 1 : 0,
                    flyingFromGrid: mealTap != nil,
                    userId: isLogged ? userid : nil,
                    onClose: dismissModal)
                    .matchedGeometryEffect(id: matchGridToModal ? mealTap! : "0", in: ns_grid, isSource: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
                    .onDisappear { flyFromGridToModal = false }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                    .zIndex(4)
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
