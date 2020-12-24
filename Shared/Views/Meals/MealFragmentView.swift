//
//  MealFragmentView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/16/20.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MealFragmentView: View {
    //MARK: Properties
    @EnvironmentObject var networkingController: ApolloNetworkingController
    let meal: MealFragment
    
    //MARK: Computed Properties
    var body: some View {
        
        KFImage(parse(object: self.meal),
                options: [
                    .transition(.fade(0.2)),
                    .processor(
                        DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
                    ),
                    .cacheOriginalImage
                ])
            .placeholder {
                HStack {
                    Image("009-eggplant")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(10)
                    Text("Loading...").font(.title)
                }
                .foregroundColor(.gray)
            }
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 175)
            .frame(height: 225)
            .overlay(
                VStack{
                    HStack {
                        Text(meal.name ?? "No name")
                            .font(.body)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, 1)
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                    }
                    HStack {
                        Text(meal.description ?? "No description")
                            .font(.footnote)
                            .minimumScaleFactor(0.5)
                            .padding(.leading)
                            .padding(.bottom)
                            .lineLimit(1)

                        Spacer()
                    }
                }.background(BlurView(style: .systemMaterial))
                , alignment: .bottom)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        
    }
    

}

//MARK: Functions
func parse(object: MealFragment) -> URL {
    guard let mealImage = object.mealImage?.publicUrlTransformed else { return URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1598621202/veggily/5f490612c53b900a6dcdc484.png")! }
    return URL(string: mealImage)!
}
