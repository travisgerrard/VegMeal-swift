//
//  View_Extention.swift
//  VegMeal (iOS)
//
//  Created by Travis Gerrard on 4/2/21.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
