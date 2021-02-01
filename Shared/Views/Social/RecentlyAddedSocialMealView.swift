//
//  RecentlyAddedSocialMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/2/21.
//

import SwiftUI

struct RecentlyAddedSocialMealView: View {
    @State var meal: MealDemo

    var body: some View {
            VStack {
                MealFragmentCoreDataView(meal: meal)
                if meal.createdAt != nil {
                    Text("Added: \(meal.createdAt!, style: .date)").font(.footnote).offset(y:-15)
                } else {
                    Text("Added: N/A").font(.footnote).offset(y:-15)
                }
            }



    }
    
   
}

//struct RecentlyAddedSocialMealView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentlyAddedSocialMealView(meal: MealFragment.example)
//    }
//}
