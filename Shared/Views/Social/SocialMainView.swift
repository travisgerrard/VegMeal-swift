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
                            
                            HStack {
                                ForEach(self.socialController.recentlyAddedMeals) { meal in
                                    NavigationLink(destination: ModalViewSimplified(meal: meal)) {

                                    RecentlyAddedSocialMealView(meal: meal)
                                    }.buttonStyle(FlatLinkStyle())
                                }
                            }
                        }
                        Text("Recently Commented Meals")
                            .font(.headline)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(self.socialController.recentlyAddedComments) { mealLog in
                                    NavigationLink(destination: ModalViewSimplified(meal: (mealLog.meal?.fragments.mealFragment)!)) {

                                    RecentlyCommentedSocialMealView(mealLog: mealLog)
                                    }.buttonStyle(FlatLinkStyle())
                                }
                            }
                        }
                    }
                    
                }
                .navigationTitle("Social")
                .navigationBarItems(leading: LoadingSubView(queryLoading: self.socialController.getMealsForSocialQueryRunning, reload: {self.socialController.getMealsForSocial(authorId: userid, followers: self.userController.followingUsers)}))
                .onAppear {
                    self.socialController.getMealsForSocial(authorId: userid, followers: self.userController.followingUsers)
                }
            }
                
            }
            
        } else {
            LoginInCreateAccountPromt()
        }
    }
    
    struct FlatLinkStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
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

struct LoadingSubView: View {
    @AppStorage("userid") var userid = ""
    var queryLoading: Bool
    let reload: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                if queryLoading {
                    ProgressView().padding(.leading).padding(.all, 10)
                } else {
                    
                    Button(action: reload) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 17, weight: .bold))
                            .padding(.all, 10)
                            .clipShape(Circle())
                    }
                    .padding(.leading)
                }
                
                
                Spacer()
                
            }
            Spacer()
        }.zIndex(1.1)
    }
}
