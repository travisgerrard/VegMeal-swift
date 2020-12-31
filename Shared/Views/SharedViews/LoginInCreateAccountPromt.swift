//
//  LoginInCreateAccountPromt.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/24/20.
//

import SwiftUI

struct LoginInCreateAccountPromt: View {
    @State var showLogin = false

    var body: some View {
        VStack {
            Text("Please log in or create an account")
            Button(action: {showLogin.toggle()}) {
                HStack(alignment: .center) {
                    Image(systemName: "person")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 26, height: 36, alignment: .center)
                        .clipShape(Circle())
                        .padding(.leading)
                        .padding(.bottom)
                    Text("Login/SignUp").font(.system(size: 16, weight: .medium)).padding(.bottom)
                }
               
            }.sheet(isPresented: $showLogin, onDismiss: {}) {
                LoginView(showLogin: $showLogin)
            }
        }    }
}

struct LoginInCreateAccountPromt_Previews: PreviewProvider {
    static var previews: some View {
        LoginInCreateAccountPromt()
    }
}
