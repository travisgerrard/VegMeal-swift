//
//  ContentView.swift
//  Shared
//
//  Created by Travis Gerrard on 8/21/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @EnvironmentObject var user: UserStore // get user
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    @EnvironmentObject var mealListController: MealListApolloController
    
    @Namespace private var ns_grid // ids to match grid elements with modal
    @Namespace private var ns_favorites // ids to match favorite icons with modal
    @Namespace private var ns_search // ids to match grid elements with modal
    
    
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
    
    func parse(object: MealFragment) -> String {
        guard let mealImage = object.mealImage?.publicUrlTransformed else { return "" }
        
        return mealImage
    }
    
    var body: some View {
        ZStack {
            //-------------------------------------------------------
            // Main View: Grid (zIndex = 1)
            // Headerview: Add meal button, Meal Plan (zIndex = 2)
            //-------------------------------------------------------
            VStack {
                TabView {
                    
                    ZStack {
                        MealsHeaderView(searchTap: $searchTap, blur: $blur, ns_search: ns_search).zIndex(2)
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
                                                    //                                        .onTapGesture(count: 2) { toggleFavoriteStatus(item) }
                                                    .onTapGesture(count: 1) { openModal(item, fromGrid: true) }
                                                    .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                                            }
                                        }
                                    }
                                }
                                .navigationBarTitle("Veggily")
                            }.zIndex(1)
                        }
                    }
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                        Text("All Meals")
                    }.tag(0)
                    
                    GroceryListView()
                        .tabItem {
                            Image(systemName: "bag")
                            Text("Grocery List")
                        }.tag(1)
                    
                    MealListView()
                        .tabItem {
                            Image(systemName: "text.book.closed")
                            Text("Meal Planner")
                        }.tag(2)
                    
                }
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
                    userId: user.isLogged ? user.userid : nil,
                    onClose: dismissModal)
                    .matchedGeometryEffect(id: matchGridToModal ? mealTap! : "0", in: ns_grid, isSource: false)
                    .matchedGeometryEffect(id: matchFavoriteToModal ? favoriteTap! : "0", in: ns_favorites, isSource: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
                    .onDisappear { flyFromGridToModal = false }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                    .zIndex(4)
            }
            
            if searchTap {
                SearchView(shouldCloseView: $searchTap)
                    //                    .matchedGeometryEffect(id: searchTap ? "search" : "0", in: ns_search, isSource: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
                    .onDisappear { flyFromGridToModal = false }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                    .onDisappear {blur = false}
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserStore())
            .environmentObject(ApolloNetworkingController())
            .environmentObject(GroceryListApolloController())
            .environmentObject(MealListApolloController())
            .environmentObject(MealLogApolloController())
    }
}






struct MealsHeaderView: View {
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("email") var email = ""
    @AppStorage("userid") var userid = ""
    @AppStorage("token") var token = ""

    @EnvironmentObject var user: UserStore // get user
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    
    
    // Add Meal Modal Showing
    @State private var showAddMealModal: Bool = false
    @State private var isLoadingIsUserAuthenticated: Bool = false
    @State private var showingAlert = false
    @State var showLogin = false
    @Binding var searchTap: Bool
    @Binding var blur: Bool
    var ns_search: Namespace.ID
    
    var body: some View {
        VStack {
            HStack {
                if isLoadingIsUserAuthenticated {
                    ProgressView()
                        .padding(.leading)
                        .padding(.bottom)
                } else {
                    if isLogged {
                        Button(action: {self.showingAlert = true}) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 36, height: 36, alignment: .center)
                                .clipShape(Circle())
                                .padding(.leading)
                                .padding(.bottom)
                        }.alert(isPresented:$showingAlert) {
                            Alert(title: Text("Are you sure you want to logout?"), message: Text("Logout?"), primaryButton: .destructive(Text("Logout")) {
                                
                                email = ""
                                userid = ""
                                isLogged = false
                                token = ""

                                
                            }, secondaryButton: .cancel())
                        }
                        
                    } else {
                        Button(action: {showLogin.toggle()}) {
                            Image(systemName: "person")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 36, height: 36, alignment: .center)
                                .clipShape(Circle())
                                .padding(.leading)
                                .padding(.bottom)
                        }.sheet(isPresented: $showLogin, onDismiss: {}) {
                            LoginView(showLogin: $showLogin)
                        }
                    }
                }
                
                
                Spacer()
                Button(action: {
                        searchTap.toggle()
                        withAnimation(.basic) {
                            blur = true
                        }                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 17, weight: .medium))
                        .frame(width: 36, height: 36, alignment: .center)
                        .clipShape(Circle())
                        .padding(.trailing)
                        .padding(.bottom)
                        .matchedGeometryEffect(id: "search", in: ns_search, isSource: true)
                }
                
                // Only show addmeal if user is logged in
                if isLogged{
                    Button(action: {showAddMealModal = true}) {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .font(.system(size: 17, weight: .medium))
                            .frame(width: 36, height: 36, alignment: .center)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .padding(.bottom)
                    }.sheet(isPresented: $showAddMealModal, onDismiss: {}) {
                        AddMealView(showModal: self.$showAddMealModal)
                            .environmentObject(self.user)
                            .environmentObject(self.networkingController)
                    }
                }
                
            }.onAppear{
                isLoadingIsUserAuthenticated = true
                let query = IsAuthenticatedUserQuery()
                ApolloController.shared.apollo.fetch(query: query) { result in
                    isLoadingIsUserAuthenticated = false
                    switch result {
                    case .failure(let error):
                        print(error)
                        
                    case .success(let graphQLResult):
                        
                        if let error = graphQLResult.errors {
                            email = ""
                            userid = ""
                            isLogged = false
                            
                            print(error)
                            return
                        }
                        
                        guard let userDetails = graphQLResult.data?.authenticatedUser else {
                            email = ""
                            userid = ""
                            isLogged = false
                            
                            return
                        }
                        
                        email = userDetails.email!
                        userid = userDetails.id
                        isLogged = true
                        
                    }
                }
            }
            Spacer()
        }
    }
}
