//
//  AccountButton.swift
//  VegMeal
//
//  Created by Travis Gerrard on 3/31/21.
//

import SwiftUI

struct AccountButton: View {
    @EnvironmentObject var userController: UserApolloController
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false
    @State var showLogin = false
    @State var accountTap = false

    var showEditAccountButton: some View {
        Button(action: {
            self.accountTap.toggle()
        }, label: {
            Label("Account", systemImage: "person.fill")
        })
        .sheet(isPresented: $accountTap) {
            UserView(showModal: $accountTap)
                .environmentObject(self.userController)
        }
    }

    var showLoginToAccountButton: some View {
        Button(
            action: { showLogin.toggle() },
            label: { Label("Login/SignUp", systemImage: "person") })
            .sheet(isPresented: $showLogin) {
                LoginView(showLogin: $showLogin)
            }
    }

    var body: some View {
        VStack {
            if userController.getUserQueryRunning {
                ProgressView()
            } else {
                if isLogged {
                    showEditAccountButton
                } else {
                    showLoginToAccountButton
                }
            }
        }

    }
}
