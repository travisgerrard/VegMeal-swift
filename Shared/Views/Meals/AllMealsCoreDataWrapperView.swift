//
//  AllMealsCoreDataWrapperView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import SwiftUI

struct AllMealsCoreDataWrapperView: View {
    @EnvironmentObject var userController: UserApolloController

    @Binding var searchTap: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                AllMealsCoreDataView()
            }
            .navigationBarTitle("Veggily")
            .navigationBarItems(leading: AccountButton())
        }
        .onAppear{
            userController.getUserQueryRunning = true
            userController.getUserData()
            
        }
    }
}

struct AccountButton:View {
    @EnvironmentObject var userController: UserApolloController
    @AppStorage("isLogged") var isLogged = false
    @State var showLogin = false
    @State var accountTap: Bool = false

    var body: some View {
        if userController.getUserQueryRunning {
            ProgressView()
        } else {
            if isLogged {
                Button(action: {
                        accountTap.toggle()
                }) {
                        Label("Account", systemImage: "person.fill")
                }.sheet(isPresented: $accountTap, onDismiss: {}) {
                    UserView(onClose: {}, pct: 1, showModal: $accountTap)
                        .environmentObject(self.userController)
                }
                
                
                // This was for when clicking user logged user out
                
                
            } else {
                Button(action: {showLogin.toggle()}) {
                        Label("Login/SignUp", systemImage: "person")
                }.sheet(isPresented: $showLogin, onDismiss: {}) {
                    LoginView(showLogin: $showLogin)
                }
            }
        }
    }
}

struct AllMealsCoreDataWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        AllMealsCoreDataWrapperView(searchTap: .constant(false))
            .environmentObject(UserApolloController())
            .environmentObject(ApolloNetworkingController())
    }
}
