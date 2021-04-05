//
//  MealFragmentCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MealFragmentCoreDataView: View {
    var meal: MealDemo
    var wideView = false

    // Even though we wont be reading from this FetchRequest in this view
    // you need it for the changes to be reflected immediately in your view.

    @FetchRequest(entity: MealDemo.entity(), sortDescriptors: []) var meals: FetchedResults<MealDemo>

    var body: some View {
        KFImage(meal.mealImageUrl,
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
            .frame(maxWidth: wideView ? .infinity : 175, maxHeight: wideView ? .infinity :225)
            .overlay(
                VStack {
                    HStack {
                        Text(meal.mealName)
                            .foregroundColor(.primary)
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
                        Text(meal.mealDetail)
                            .foregroundColor(.primary)
                            .font(.footnote)
                            .minimumScaleFactor(0.5)
                            .padding(.leading)
                            .padding(.bottom)
                            .lineLimit(1)

                        Spacer()
                    }
                }
                .background(
                    BlurView(
                        style: .systemMaterial
                    )
                ),
                alignment: .bottom
            )
            .cornerRadius(
                30,
                corners: wideView ? [.topLeft, .topRight] : [.topLeft, .topRight, .bottomLeft, .bottomRight]
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.bottom, 30)
    }
}

struct MealFragmentCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        MealFragmentCoreDataView(meal: MealDemo.example)
    }
}
