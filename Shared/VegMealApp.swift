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
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

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
                // For swift ui to read coredata values
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController) // For our own code
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.willResignActiveNotification
                    ), perform: save)
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
