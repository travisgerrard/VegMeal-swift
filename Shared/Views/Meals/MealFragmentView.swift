//
//  MealFragmentView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/16/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MealFragmentView: View {
    //MARK: Properties
    @EnvironmentObject var networkingController: ApolloNetworkingController
    let meal: MealFragment
    let namespace: Namespace.ID
    @Binding var showIndavidualMeal: Bool
    @Binding var isDisabled: Bool

    //MARK: Computed Properties
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                WebImage(url: self.parse(object: self.meal))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            }
            Divider().background(Color.black).padding(.horizontal)
            HStack {
                VStack(alignment: .leading) {
                    Text(meal.name ?? "No name")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                    
                    Text(meal.description ?? "No description")
                        .font(.subheadline)
                }
                .padding(.bottom)
                .padding(.leading)
                Spacer()
            }
        }
        .matchedGeometryEffect(id: "\(meal.id ?? "")Photo", in: namespace)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .onTapGesture {
            withAnimation(.spring()) {
                self.networkingController.meal = meal
                showIndavidualMeal.toggle()
                isDisabled = true
                
            }
        }
    }
    
    //MARK: Functions
        func parse(object: MealFragment) -> URL {
            guard let mealImage = object.mealImage?.publicUrlTransformed else { return URL(string: "")! }
            
            return URL(string: mealImage)!
        }
}

