//
//  MealListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/23/20.
//

import SwiftUI

struct MealListView: View {
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var mealListController: MealListApolloController
    
    var body: some View {
        if user.isLogged {
            NavigationView {
                List {
                    ForEach(self.mealListController.mealList) {meal in
                        HStack {
                            Button(action: {
                            }) {
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                                    .frame(width: 32, height: 32)
                                    .padding(.trailing, 3)
                            }
                            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                        .onChanged { _ in
                                        }
                                        .onEnded { _ in
                                            self.mealListController.completeMealListItem(id: meal.id!)
                                        }
                            )
                            Text("\(meal.meal?.name ?? "No name")")
                            Spacer()
                            Button(action: {
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.all, 10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .gesture(TapGesture()
                                        .onEnded {
                                            self.mealListController.deleteMealListItem(id: meal.id!)
                                        }
                            )
                        }
                    }
                }
                .navigationBarTitle("Meal Planner")
                .onAppear {
                    self.mealListController.getMealList(userId: user.userid)
                }
            }
        } else {
            Text("Please log in or create an account")

        }
        
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
