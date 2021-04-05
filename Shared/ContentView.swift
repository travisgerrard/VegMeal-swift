//
//  ContentView.swift
//  Shared
//
//  Created by Travis Gerrard on 8/21/20.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var userController: UserApolloController
    
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
        
    @SceneStorage("selectedView") var selectedView: String?

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedView) {
                    AllMealsCoreDataWrapperView()
                        .tabItem {
                            Image(systemName: "rectangle.stack")
                            Text("All Meals")
                        }.tag(AllMealsCoreDataWrapperView.tag)
                    
                    GroceryListCoreDataView()
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Grocery List")
                        }.tag(GroceryListCoreDataView.tag)
                    
                    MealListCoreDataView()
                        .tabItem {
                            Image(systemName: "folder")
                            Text("Meal Planner")
                        }.tag(MealListCoreDataView.tag)
                    
                    SocialMainCoreDataView(userid: userid)
                        .tabItem {
                            Image(systemName: "rectangle.stack.person.crop")
                            Text("Social")
                        }
                        .tag(SocialMainCoreDataView.tag)
                }
            }
        }
        .onAppear {
            dataController.loadAllDataAndSync()
            userController.getUserData()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environmentObject(ApolloNetworkingController())
            .environmentObject(UserApolloController())
            .environmentObject(dataController)
    }
}
