//
//  OptionsList.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/30/20.
//

// Shows the options available when looking for ingredient or amount

import SwiftUI

struct OptionsList: View {
    var list = [String]()
    @Binding var text: String
    @Binding var isEditing: Bool
    
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(list, id: \.self) { string in
                    HStack {
                        Text(string).padding(.leading)
                        Spacer()
                    }.onTapGesture(count:1) {
                        text = string
                        isEditing = false
                        hideKeyboard()
                    }.padding(.top, 5)
                    Divider().padding(0)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 300)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 5)
            
            Spacer()
        }.zIndex(10)
    }
}

struct OptionsList_Previews: PreviewProvider {
    static var previews: some View {
        OptionsList(list: ["1","1","1","1","1"], text: .constant("Text"), isEditing: .constant(false))
    }
}
