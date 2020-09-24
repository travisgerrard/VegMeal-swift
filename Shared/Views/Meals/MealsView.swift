//
//  MealsView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MealsView: View {
    //Get the networking controller from the environment objects.
    @EnvironmentObject var networkingController: ApolloNetworkingController
    @EnvironmentObject var user: UserStore

    @Binding var showProfile: Bool
    @Binding var viewState: CGSize
    let namespace: Namespace.ID
    @Binding var showIndavidualMeal: Bool
    @Binding var isDisabled: Bool
    @State var showAddMealModal = false


    var body: some View {
            
            GeometryReader { bounds in
                ScrollView {
                    VStack {
                        HStack {
                            AvatarView(showProfile: $showProfile)
                                .padding(.leading)
                                .padding(.bottom)
                            Spacer()

                            if user.isLogged{
                                Button(action: {showAddMealModal = true}) {
                                    Image(systemName: "rectangle.stack.badge.plus")
//                                        .foregroundColor(.primary)
                                        .font(.system(size: 17, weight: .medium))
                                        .frame(width: 36, height: 36, alignment: .center)
                                        .background(Color("background3"))
                                        .clipShape(Circle())
                                        .padding(.trailing)
                                        .padding(.bottom)
                                }.sheet(isPresented: $showAddMealModal, onDismiss: {}) {
                                    AddMealView()
                                        .environmentObject(self.user)
                                        .environmentObject(self.networkingController)
                                }
                            }
                            
                           
                            
                        }
                        
                        if self.networkingController.mealsQueryError != nil {
                            Text("There was an error making the request: \(self.networkingController.mealsQueryError?.localizedDescription ?? "Unknown error")").multilineTextAlignment(.center).padding()
                            Spacer()
                        } else {
                            ForEach(self.networkingController.meals){ meal in
                                MealFragmentView(meal: meal, namespace: namespace, showIndavidualMeal: $showIndavidualMeal, isDisabled: $isDisabled)
                            }
                        }
                    }
                    
                }
                .frame(width: bounds.size.width)
                .offset(y: showProfile ? -450 : 0)
                .rotation3DEffect(
                    Angle(degrees: showProfile ? Double(viewState.height / 10) - 10 : 0),
                    axis: (x: 10.0, y: 0.0, z: 0)
                )
                .scaleEffect(showProfile ? 0.9 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                
                            
            }
            
        
        
    }
}

struct MealsView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        MealsView(showProfile: .constant(false), viewState: .constant(.zero), namespace: namespace, showIndavidualMeal: .constant(false), isDisabled: .constant(false))
            .environmentObject(UserStore())
            .environmentObject(ApolloNetworkingController())

    }
}
