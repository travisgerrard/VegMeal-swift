//
//  ContentView.swift
//  Shared
//
//  Created by Travis Gerrard on 8/21/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userController: UserApolloController

    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""
    
    @State private var searchTap: Bool = false
      
    @SceneStorage("selectedView") var selectedView: String?

    func loadMealDemo() {
        if userid != "" && isLogged {
            let query = UpdateAllOnLaunchQuery(userId: userid)
            ApolloController.shared.apollo.fetch(query: query) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResult):
                    print("!!!! - Loaded update all query")
                    if let data = graphQLResult.data {
                        // Load meals
                        if let allMeals = data.allMeals {
                            for meal in allMeals {
                                if let mealDemoFragment = meal?.fragments.mealDemoFragment {

                                    // Loads all meals into DB
                                    _ = MealDemo.object(in:managedObjectContext, withFragment: mealDemoFragment)
                                    
                                }
                            }
                        }
                        
                        // Load ingredients/amounts
                        if let allAmounts = data.allAmounts {
                            for amount in allAmounts {
                                if let amountFragment = amount?.fragments.amountFragment {
                                    _ = AmountDemo.object(in: managedObjectContext, withFragment: amountFragment)
                                }
                            }
                        }
                        if let allIngredients = data.allIngredients {
                            for ingredient in allIngredients {
                                if let ingredientFragment = ingredient?.fragments.ingredientFragment {
                                    _ = IngredientDemo.object(in: managedObjectContext, withFragment: ingredientFragment)
                                }
                            }
                        }
                        
                        
                        // Load grocery list
                        if let allGroceryLists = data.allGroceryLists {
                            // Delete prior grocery lists
                            let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = GroceryList.fetchRequest()
                            let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
                            _ = try? managedObjectContext.execute(batchDeleteRequest3)
                            
                            for groceryItem in allGroceryLists {
                                if let groceryListFragment = groceryItem?.fragments.groceryListFragment {
                                    
                                    _ = GroceryList.object(in: managedObjectContext, withFragment: groceryListFragment)
                                    
                                    try? managedObjectContext.save()
                                    
                                }
                            }
                        }
                        
                        // Load meal list
                        if let allMealLists = data.allMealLists {
                            // Delete prior meal lists
                            let fetchRequest6: NSFetchRequest<NSFetchRequestResult> = MealList.fetchRequest()
                            let batchDeleteRequest6 = NSBatchDeleteRequest(fetchRequest: fetchRequest6)
                            _ = try? managedObjectContext.execute(batchDeleteRequest6)
                            
                            for mealListItem in allMealLists {
                                if let mealListFragment = mealListItem?.fragments.mealListFragment {
                                    
                                    
                                    let mealListItemDB = MealList.object(in: managedObjectContext, withFragment: mealListFragment)
                                    
                                    let mealListMeal = MealDemo.object(in: managedObjectContext, withFragment: mealListFragment.meal?.fragments.mealDemoFragment)
                                    
                                    mealListItemDB?.meal = mealListMeal
                                }
                            }
                        }
                        
                        // Load user
                        if let allUsers = data.allUsers {
                            if allUsers.count > 0 {
                                if let currentUser = allUsers[0]?.fragments.userDemoFragment {
                                    let currentUserDB = UserDemo.object(in: managedObjectContext, withFragment: currentUser)
                                    
                                    allUsers[0]?.follows.forEach {
                                        let followsUserDB = UserDemo.object(in: managedObjectContext, withFragment: $0.fragments.userDemoFragment)
                                        
                                        currentUserDB?.mutableSetValue(forKey: "follows").add(followsUserDB!)
                                        
                                    }
                                    try? managedObjectContext.save()
                                }
                                
                            }
                        }
                        
                        try? managedObjectContext.save()
                    }
                }
            }
        } else {
            let query = AllMealsDemoQuery()
            ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    print("!!!! - Loaded all meals")
                    if let data = graphQLResult.data {
                        if let allMeals = data.allMeals {
                            for meal in allMeals {
                                if let mealDemoFragment = meal?.fragments.mealDemoFragment {

                                    // Loads all meals into DB
                                    _ = MealDemo.object(in:managedObjectContext, withFragment: mealDemoFragment)
                                    
                                }
                            }
                            try? managedObjectContext.save()
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedView) {
                    AllMealsCoreDataWrapperView(searchTap: $searchTap)
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                        Text("All Meals")
                    }.tag(AllMealsView.tag)
                    
                    GroceryListCoreDataView()
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Grocery List")
                        }.tag(GroceryListView.tag)
                    
                    MealListCoreDataView()
                        .tabItem {
                            Image(systemName: "folder")
                            Text("Meal Planner")
                        }.tag(MealListView.tag)
                    
                        SocialMainCoreDataView(userid: userid)
                        .tabItem {
                            Image(systemName: "rectangle.stack.person.crop")
                            Text("Social")
                        }
                        .tag(SocialMainView.tag)
                }
            }
        }
        .onAppear{
            self.loadMealDemo()
            userController.getUserData()
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApolloNetworkingController())
            .environmentObject(GroceryListApolloController())
            .environmentObject(MealListApolloController())
            .environmentObject(MealLogApolloController())
            .environmentObject(UserApolloController())
    }
}






struct MealsHeaderView: View {
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("email") var email = ""
    @AppStorage("userid") var userid = ""
    @AppStorage("token") var token = ""

    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    @EnvironmentObject var userController: UserApolloController

    
    // Add Meal Modal Showing
    @State private var showAddMealModal: Bool = false
    @State var showLogin = false
    @Binding var searchTap: Bool
    @Binding var accountTap: Bool

    @Binding var blur: Bool
    var ns_search: Namespace.ID
    
    var body: some View {
        VStack {
            HStack {
                if userController.getUserQueryRunning {
                    ProgressView()
                        .padding(.leading)
                        .padding(.bottom)
                } else {
                    if isLogged {
                        Button(action: {
                                accountTap.toggle()
                                withAnimation(.basic) {
                                    blur = true
                                }
                        }) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 36, height: 36, alignment: .center)
                                .clipShape(Circle())
                                .padding(.leading)
                                .padding(.bottom)
                        }
                        
                        // This was for when clicking user logged user out
                        
                        
                    } else {
                        Button(action: {showLogin.toggle()}) {
                            HStack(alignment: .center) {
                                Image(systemName: "person")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 26, height: 36, alignment: .center)
                                    .clipShape(Circle())
                                    .padding(.leading)
                                    .padding(.bottom)
                                Text("Login/SignUp").font(.system(size: 16, weight: .medium)).padding(.bottom)
                            }
                           
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
                            .environmentObject(self.networkingController)
                    }
                }
                
            }.onAppear{
                userController.getUserQueryRunning = true
                userController.getUserData()
                
            }
            Spacer()
        }
    }
}
