//
//  SocialMainView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/1/21.
//

import SwiftUI

struct SocialMainView: View {
    @EnvironmentObject var userController: UserApolloController
    @EnvironmentObject var socialController: SocialApolloController
    @EnvironmentObject var networkingController: ApolloNetworkingController   
    
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""
    
    let c = GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 10)
    
    static let tag: String? = "SocialView"
    
    var body: some View {
        if isLogged {
            ZStack{
                
                
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Recently Added Meals")
                            .font(.headline)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            LazyHGrid(rows: [c], spacing: 20) {
                                ForEach(self.socialController.recentlyAddedMeals) { meal in
                                    NavigationLink(destination: ModalViewSimplified(meal: meal)) {

                                    RecentlyAddedSocialMealView(meal: meal)
                                    }
                                }
                            }
                        }
                        Text("Recently Commented Meals")
                            .font(.headline)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 0) {
                                ForEach(self.socialController.recentlyAddedComments) { mealLog in
                                    NavigationLink(destination: ModalViewSimplified(meal: (mealLog.meal?.fragments.mealFragment)!)) {

                                    RecentlyCommentedSocialMealView(mealLog: mealLog)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .navigationTitle("Social")

                .onAppear {
                    self.socialController.getMealsForSocial(authorId: userid, followers: self.userController.followingUsers)
                }
            }
//                VStack {
//                    HStack {
//                        if self.socialController.getMealsForSocialQueryRunning {
//                            ProgressView().padding(.leading).padding(.all, 10)
//                        } else {
//                            Button(action: {
//                                self.socialController.getMealsForSocial(authorId: userid, followers: self.userController.followingUsers)
//                            }) {
//                                Image(systemName: "arrow.triangle.2.circlepath")
//                                    .font(.system(size: 17, weight: .bold))
//                                    .padding(.all, 10)
//                                    .clipShape(Circle())
//                            }
//                            .padding(.leading)
//                        }
//                        
//                        
//                        Spacer()
//                        
//                    }
//                    Spacer()
//                }.zIndex(1.1)
            }
            
        } else {
            LoginInCreateAccountPromt()
        }
    }
}

struct SocialMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        SocialMainView()
            .environmentObject(UserApolloController())
            .environmentObject(SocialApolloController())
    }
}
