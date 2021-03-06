//
//  UserApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/8/20.
//


import Apollo
import Combine
import SwiftUI

struct OtherUser: Identifiable {
    var id: String
    var isFollowing: Bool
    var name: String
    var email: String
}

class UserApolloController: ObservableObject {
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false
    @AppStorage("email", store: UserDefaults.shared) var email = ""
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
    @AppStorage("token", store: UserDefaults.shared) var token = ""
    
    @Published var getUserQueryRunning: Bool = false
    @Published var getUserQueryError: Error?
    @Published var loggedInUser: UserFragment?
    
    @Published var otherUsers: [OtherUser] = []
    @Published var otherUsersFragment: [UserFragment] = []

    
    func getUserData() {
//        self.getUserQueryRunning = true
        let query = CurrentUserQueryQuery()
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
            self.getUserQueryRunning = false
            
            switch result {
            case .failure(let error):
                self.getUserQueryError = error
                
            case .success(let graphQlResults):
//                print("Success getUserData: \(graphQlResults)")
                if let error = graphQlResults.errors {
                    self.email = ""
                    self.userid = ""
                    self.isLogged = false
                    
                    print(error)
                    return
                }
                
                guard let userDetails = graphQlResults.data?.authenticatedUser?.fragments.userFragment else {
                    self.email = ""
                    self.userid = ""
                    self.isLogged = false
                    
                    print("Not an authenticated user")
                    return
                }
                
                self.email = userDetails.email!
                self.userid = userDetails.id
                self.loggedInUser = userDetails
                self.isLogged = true
                print("Is an authenticated user")
                self.getUsers()
            }
        }
    }
    
    @Published var getUsersQueryRunning: Bool = false
    @Published var getUsersQueryError: Error?
    
    func getUsers() {
        var otherUserFragment: UserFragment?
        var isFollowingUser: Bool?
        
        self.getUsersQueryRunning = true
        let query = AllUsersQuery()
        
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            self.getUsersQueryRunning = false
            
            switch result {
            case .failure(let error):
                self.getUserQueryError = error
                
            case .success(let graphQlResults):
//                print("Success: getUsers: \(graphQlResults)")
                
                guard let returnedListOfUsers = graphQlResults.data?.allUsers else { break }
                
                self.otherUsers.removeAll()
                for returnedUser in returnedListOfUsers {
                    otherUserFragment = returnedUser!.fragments.userFragment
                    isFollowingUser = self.loggedInUser!.follows.firstIndex(where: {$0.id == otherUserFragment!.id}) != nil
                    // Not currently logged in user
                    if returnedUser!.fragments.userFragment.id != self.userid {
//                        print(returnedUser!.fragments.userFragment.id)
                        self.otherUsers.append(OtherUser(id: otherUserFragment!.id, isFollowing: isFollowingUser!, name: otherUserFragment!.name!, email: otherUserFragment!.email!))
                    }
                }
            }
        }
    }
    
    func logUserOut() {
        self.email = ""
        self.userid = ""
        self.isLogged = false
        self.token = ""
        self.loggedInUser = nil
    }
    
    @Published var startFollowingMutationRunning: Bool = false
    @Published var startFollowingMutationError: Error?
    
    func startFollowingUser(idToChangeFollowing: String, currentUser: String) {
        print("startFollowingUser was called")
        self.startFollowingMutationRunning = true
        let mutation = StartFollowingMutation(id_to_change_following: idToChangeFollowing, current_user: currentUser)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            self.startFollowingMutationRunning = false
            
            switch result {
            case .failure(let error):
                self.startFollowingMutationError = error
                
            case .success(let graphQlResults):
                //                print(graphQlResults)
                if let error = graphQlResults.errors {
                    print(error)
                    return
                }

            }
            
        }
    }
    
    @Published var stopFollowingMutationRunning: Bool = false
    @Published var stopFollowingMutationError: Error?
    
    func stopFollowingUser(idToChangeFollowing: String, currentUser: String) {
        print("stopFollowingUser was called")
        self.stopFollowingMutationRunning = true
        let mutation = StopFollowingMutation(id_to_change_following: idToChangeFollowing, current_user: currentUser)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            self.stopFollowingMutationRunning = false
            
            switch result {
            case .failure(let error):
                self.stopFollowingMutationError = error
                
            case .success(let graphQlResults):
//                print(graphQlResults)
                if let error = graphQlResults.errors {
                    print(error)
                    return
                }

            }

        }
    }

}

extension UserApolloController {
    var followingUsers: [OtherUser] {
        otherUsers.filter {
            $0.isFollowing == true
        }
        
    }
}
