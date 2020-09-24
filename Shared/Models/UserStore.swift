//
//  UserStore.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/7/20.
//

import SwiftUI
import Combine

class UserStore: ObservableObject {
    @Published var isLogged: Bool = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            UserDefaults.standard.setValue(isLogged, forKeyPath: "isLogged")
        }
    }
    
    @Published var token: String = UserDefaults.standard.string(forKey: "token") ?? "" {
        didSet {
            UserDefaults.standard.setValue(token, forKey: "token")
        }
    }
    @Published var userid: String = UserDefaults.standard.string(forKey: "userid") ?? "" {
        didSet {
            UserDefaults.standard.setValue(userid, forKey: "userid")
        }
    }
    @Published var email: String = UserDefaults.standard.string(forKey: "email") ?? "" {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "email")
        }
    }
    @Published var showLogin = false
    
    init(mockUserId: String? = nil) {
            if let userid = mockUserId {
                self.userid = userid
            }
        }
}

