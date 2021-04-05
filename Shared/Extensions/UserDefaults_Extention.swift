//
//  UserDefaults_Extention.swift
//  VegMeal
//
//  Created by Travis Gerrard on 3/31/21.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.gerrardApps.VegMeal.veggilyData")!
    }
}
