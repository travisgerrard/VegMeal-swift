//
//  Home.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/7/20.
//

import SwiftUI

struct Home: View {

    var body: some View {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                ContentView()
            }
    }
}

let screen = UIScreen.main.bounds

struct Home_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        Home()
            .environmentObject(ApolloNetworkingController())
            .environmentObject(GroceryListApolloController())
            .environmentObject(MealListApolloController())
            .environmentObject(MealLogApolloController())
            .environmentObject(SocialApolloController())
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}


