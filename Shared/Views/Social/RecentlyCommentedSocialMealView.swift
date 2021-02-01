//
//  RecentlyCommentedSocialMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/2/21.
//

import SwiftUI

struct RecentlyCommentedSocialMealView: View {
    @State var mealLog: MadeMeal
    @AppStorage("userid") var userid = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    
    var body: some View {
        VStack {
            
            
            if mealLog.meal != nil {
                MealFragmentCoreDataView(meal: mealLog.meal!, wideView: true)
//                MealFragmentView(meal: mealLog.meal!.fragments.mealFragment, wideView: true)
            }
            VStack {
                VStack {
                    VStack{
                        
                        HStack {
                            Text("Made on: \(mealLog.dateMade!, style: .date)")
                                .foregroundColor(.primary).font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("By: \(mealLog.thoughtsAuthorId == userid ? "You" : "\(mealLog.thoughtsAuthorName)")")
                                .foregroundColor(.primary).font(.headline)
                            Spacer()
                        }.padding(.bottom, 5)
                        Divider()
                        
                        HStack {
                            Text(mealLog.thoughts ?? "No thoughts enetered yet")
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 5)
                            Spacer()
                            
                        }
                        
                    }
                    .padding()
                    .frame(width: screen.width - 100)
                    .background(BlurViewTwo(active: true, onTap: {}))
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    
                    
                    Spacer()
                }
                .padding(.top, 5)
                
            }.padding().offset(y:-60)
        }
        .padding(.bottom, -70).frame(maxWidth: screen.width)
    }
}

//
//struct RecentlyCommentedSocialMealView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentlyCommentedSocialMealView(mealLog: MadeMealFragment.example)
//    }
//}

// Making it so we can have half rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
