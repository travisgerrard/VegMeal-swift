//
//  GroceryListFragment.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

extension GroceryListFragment: Identifiable {
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
}
