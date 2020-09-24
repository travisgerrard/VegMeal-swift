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
    @StateObject var userStore = UserStore()
    @StateObject var networkingController = ApolloNetworkingController()
    @StateObject var groceryListController = GroceryListApolloController()
    @StateObject var mealListController = MealListApolloController()
    @StateObject var mealLogController = MealLogApolloController()

    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(userStore)
                .environmentObject(networkingController)
                .environmentObject(groceryListController)
                .environmentObject(mealListController)
                .environmentObject(mealLogController)

        }
    }
}
