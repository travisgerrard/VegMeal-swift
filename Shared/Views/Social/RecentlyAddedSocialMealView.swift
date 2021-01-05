//
//  RecentlyAddedSocialMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/2/21.
//

import SwiftUI

struct RecentlyAddedSocialMealView: View {
    @State var meal: MealFragment

    var body: some View {
            VStack {
                MealFragmentView(meal: meal)
                if meal.dateCreated != nil {
                    Text("Added: \(meal.dateCreated!, style: .date)").font(.footnote).offset(y:-15)
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
