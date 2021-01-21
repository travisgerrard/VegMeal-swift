//
//  GroceryListFragment.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

extension GroceryListFragment {
    var options: [Int: String] {
        [
            0: "none",
            1: "produce",
            2: "bakery",
            3: "frozen",
            4: "baking & spices",
            5: "nuts, seeds & dried fruit",
            6: "rice, grains & beans",
            7: "canned & jarred goods",
            8: "oils, sauces & condiments",
            9: "ethnic",
            10: "refrigerated",
        ]
    }
    
    var dateCompletedFormatted: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if dateCompleted != nil {
            let dateCompletedStr = dateCompleted
            let dateCompletedDate = dateFormatter.date(from: dateCompletedStr!)
            return dateCompletedDate
        } else {
            return nil
        }
        
    }
}
