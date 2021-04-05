//
//  SectionHeaderView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 4/5/21.
//

import SwiftUI

struct SectionHeaderView: View {
    var headerViewTitle = "dummy header view"

    var body: some View {
        VStack {
            Text(headerViewTitle)
                .foregroundColor(.white)
                .font(.title)
        }
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color.blue)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView()
    }
}
