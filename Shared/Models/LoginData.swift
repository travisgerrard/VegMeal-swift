//
//  LoginData.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import Foundation
import SwiftUI


class LoginData {
    @EnvironmentObject var user: UserStore

//    @Published var token: String?
//    var email: String
//    var password: String

    
    init() {
        print("running LoginData")
//        self.email = email
//        self.password = password
    }
    
    func loadData(email: String, password: String) {
        Network.shared.apollo.perform(mutation: AuthenticateUserMutation(email: email, password: password)) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    if let authenticateUserWithPassword = data.authenticateUserWithPassword {
                        if let token = authenticateUserWithPassword.token {
                            self.user.isLogged = true
                            UserDefaults.standard.set(true, forKey: "isLogged")

                            self.user.token = token
                            UserDefaults.standard.set(token, forKey: "token")

                            print("Set token \(token)")
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
