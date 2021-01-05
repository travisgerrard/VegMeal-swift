//
//  RecentlyCommentedSocialMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/2/21.
//

import SwiftUI

struct RecentlyCommentedSocialMealView: View {
    @State var mealLog: MadeMealFragment
    @AppStorage("userid") var userid = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    
    var body: some View {
        VStack {
            
            if mealLog.meal?.fragments.mealFragment != nil {
                MealFragmentView(meal: mealLog.meal!.fragments.mealFragment)
                
            }
            VStack {
                
                VStack {
                    VStack {
                        HStack {
                            Text("\((mealLog.author!.id == userid ? "You" : mealLog.author!.name)!) made this meal on: \(dateFormatter.string(from: dateFormatter.date(from: mealLog.dateMade!)!))")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        HStack {
                            Text(mealLog.thoughts ?? "No thoughts on this meal yet?")
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading)
                            Spacer()
                            
                        }
                        
                        .padding()
                        .background(BlurView(style: .systemMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                }
            }.padding().offset(y:-50)
            
            
        }
        .frame(width: 250).padding()
    }
}


struct RecentlyCommentedSocialMealView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyCommentedSocialMealView(mealLog: MadeMealFragment.example)
    }
}
