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
            .navigationBarItems(leading: AccountButton(), trailing:
                HStack {
                    SearchButton()
                    AddNewMealButton()
                }
            )
            .onAppear{
                userController.getUserQueryRunning = true
                userController.getUserData()
            }
        }
        
    }
}

struct AccountButton:View {
    @EnvironmentObject var userController: UserApolloController
    @AppStorage("isLogged") var isLogged = false
    @State var showLogin = false
    @State var accountTap: Bool = false
    
    var body: some View {
        VStack {
            if userController.getUserQueryRunning {
                ProgressView()
            } else {
                
                if isLogged {
                    Button(action: {
                        self.accountTap.toggle()
                    }) {
                        Label("Account", systemImage: "person.fill")
                    }.sheet(isPresented: $accountTap, onDismiss: {}) {
                        UserView(showModal: $accountTap)
                            .environmentObject(self.userController)
                    }
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
}

struct AddNewMealButton:View {
    @State private var showAddMealModal: Bool = false
    @AppStorage("isLogged") var isLogged = false
    
    var body: some View {
        if isLogged {
            Button(action: {showAddMealModal = true}) {
                Image(systemName: "rectangle.stack.badge.plus")
               
            }.sheet(isPresented: $showAddMealModal, onDismiss: {}) {
                AddMealView(showModal: self.$showAddMealModal)
            }
        }
    }
}

struct SearchButton: View {
    @State private var searchTap: Bool = false

    var body: some View {
        NavigationLink(destination: SearchCoreDataView(), label: {
            Image(systemName: "magnifyingglass")
                .padding(.trailing)
        })

    }
}

//struct AllMealsCoreDataWrapperView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllMealsCoreDataWrapperView(searchTap: .constant(false))
//            .environmentObject(UserApolloController())
//            .environmentObject(ApolloNetworkingController())
//    }
//}
