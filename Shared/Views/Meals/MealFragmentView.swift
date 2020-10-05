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
    
    //MARK: Computed Properties
    var body: some View {
        WebImage(url: self.parse(object: self.meal))
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .overlay(
                VStack{
                    HStack {
                        Text(meal.name ?? "No name")
                            .font(.title3)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, 1)

                        Spacer()
                    }
                    HStack {
                        Text(meal.description ?? "No description")
                            .font(.subheadline)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                }.background(BlurView(style: .systemMaterial))
                , alignment: .bottom)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
           
    }
    
    //MARK: Functions
    func parse(object: MealFragment) -> URL {
        guard let mealImage = object.mealImage?.publicUrlTransformed else { return URL(string: "")! }
        
        return URL(string: mealImage)!
    }
}


