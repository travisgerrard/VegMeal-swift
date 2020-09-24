//
//  ContentView.swift
//  Shared
//
//  Created by Travis Gerrard on 8/21/20.
//

import SwiftUI
import SDWebImageSwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct ContentView: View {
    @Environment(\.imageCache) var cache: ImageCache
//    @State var meal: Meal? = nil
    @State var showIndavidualMeal = false
    @Namespace var namespace
    @State var isDisabled = false
    @Binding var showProfile: Bool
    @Binding var viewState: CGSize
    @State var isScrollable = false
    
    
    
    var body: some View {
        ZStack {
            if !showIndavidualMeal {
            MealsView(showProfile: $showProfile, viewState: $viewState, namespace: namespace, showIndavidualMeal: $showIndavidualMeal, isDisabled: $isDisabled).zIndex(1)
            }
            if showIndavidualMeal {
                SingleMealFragmentView(namespace: namespace, showIndavidualMeal: $showIndavidualMeal, isDisabled: $isDisabled).zIndex(2)
            }
        }
        
        
        
        
    }
}

struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content
    
    init(_ value: Value?,
         @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }
    
    var body: some View {
        value.map(contentProvider)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showProfile: .constant(false), viewState: .constant(.zero))
            .environmentObject(UserStore())
    }
}





