//
//  VegMealApp.swift
//  Shared
//
//  Created by Travis Gerrard on 8/21/20.
//

import SwiftUI
import UIKit


@main
struct VegMealApp: App {
    @StateObject var networkingController = ApolloNetworkingController()
    @StateObject var groceryListController = GroceryListApolloController()
    @StateObject var mealListController = MealListApolloController()
    @StateObject var mealLogController = MealLogApolloController()
    @StateObject var userController = UserApolloController()
    @StateObject var searchMealController = SearchMealApolloController()
    @StateObject var socialController = SocialApolloController()

    
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(networkingController)
                .environmentObject(groceryListController)
                .environmentObject(mealListController)
                .environmentObject(mealLogController)
                .environmentObject(userController)
                .environmentObject(searchMealController)
                .environmentObject(socialController)
        }
    }
}
