//
//  Home.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/7/20.
//

import SwiftUI

struct Home: View {
    @State var showProfile = false
    @State var viewState = CGSize.zero
    @State var showContent = false
    @EnvironmentObject var user: UserStore
    
    var body: some View {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
//                HomeBackgroundView(showProfile: $showProfile)
//                    .offset(y: showProfile ? -450 : 0)
//                    .rotation3DEffect(
//                        Angle(degrees: showProfile ? Double(viewState.height / 10) - 10 : 0),
//                        axis: (x: 10.0, y: 0.0, z: 0)
//                    )
//                    .scaleEffect(showProfile ? 0.9 : 1)
//                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
//                    .edgesIgnoringSafeArea(.all)
                
                ContentView()
                
                
//                MenuView(showProfile: $showProfile)
//                    .background(Color.black.opacity(0.001))
//                    .offset(y: showProfile ? 0 : screen.height)
//                    .offset(y: viewState.height)
//                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
//                    .onTapGesture(count: 1, perform: {
//                        showProfile.toggle()
//                    })
//                    .gesture(DragGesture().onChanged{value in
//                        viewState = value.translation
//                    }
//                    .onEnded( { value in
//                        if viewState.height > 50 {
//                            showProfile = false
//                        }
//                        viewState = .zero
//                    })
//                    )
                
                
                
//                if user.showLogin {
//                    ZStack {
////                        LoginView()
//
//                        VStack {
//                            HStack {
//                                Spacer()
//                                Image(systemName: "xmark")
//                                    .frame(width: 36, height: 36)
//                                    .foregroundColor(.white)
//                                    .background(Color.black)
//                                    .clipShape(Circle())
//                            }
//                            Spacer()
//                        }
//                        .padding()
//                        .onTapGesture(count: 1, perform: {
//                            user.showLogin = false
//                        })
//                    }
//                }
            }
            
        
    }
}

let screen = UIScreen.main.bounds

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(UserStore())
            .environmentObject(ApolloNetworkingController())
            .environmentObject(GroceryListApolloController())
            .environmentObject(MealListApolloController())
            .environmentObject(MealLogApolloController())

    }
}

struct AvatarView: View {
    @Binding var showProfile: Bool
    @EnvironmentObject var user: UserStore
    
    var body: some View {
        VStack {
            if user.isLogged {
                Button(action: {showProfile.toggle()}) {
                    Image(uiImage: #imageLiteral(resourceName: "009-eggplant.png"))
//                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 36, height: 36, alignment: .center)
                        .clipShape(Circle(), style: FillStyle())
                        .foregroundColor(.blue)

                }
            } else {
                Button(action: {user.showLogin.toggle()}) {
                    Image(systemName: "person")
//                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36, alignment: .center)
                        .background(Color("background3"))
                        .clipShape(Circle())
//                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
//                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10    )
                }
            }
        }
    }
}

struct HomeBackgroundView: View {
    @Binding var showProfile: Bool
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background1")]), startPoint: .top, endPoint: .bottom).frame(height: 200)
            Spacer()
        }
        .background(Color("background1"))
        
        .clipShape(RoundedRectangle(cornerRadius: showProfile ? 30 : 0, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
    }
}
