//
//  MealPlannerFavoriteView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 10/2/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MealPlannerFavoriteView: View {
    let image: String
    var pct: CGFloat
    
    var body: some View {
        // We use EmptyView, because the modifier actually ignores
        // the value passed to its body() function.
        EmptyView().modifier(MealPlannerFavoriteViewMod(image: image, pct: pct))
    }
}

struct MealPlannerFavoriteViewMod: AnimatableModifier {
    @Environment(\.favRadiusPct) var favRadiusPct: CGFloat
    @Environment(\.favShadow) var favShadow: CGFloat

    @Environment(\.gridRadiusPct) var gridRadiusPct: CGFloat
    @Environment(\.gridShadow) var gridShadow: CGFloat

    let image: String
    var pct: CGFloat
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        let radiusPercent = (favRadiusPct - gridRadiusPct) * pct + gridRadiusPct
        let shadow = (favShadow - gridShadow) * pct + gridShadow
        
        return WebImage(url: URL(string: image))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RectangleToCircle(cornerRadiusPercent: radiusPercent))
            .overlay(RectangleToCircle(cornerRadiusPercent: radiusPercent).stroke(Color.white, lineWidth: 2 * pct))
            .padding(2 * pct)
            .overlay(RectangleToCircle(cornerRadiusPercent: radiusPercent).strokeBorder(Color.black.opacity(0.1 * Double(pct))))
            .shadow(radius: shadow)
            .padding(4 * pct)
    }
}

struct MealPlannerFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlannerFavoriteView(image: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg", pct: 1)
    }
}
