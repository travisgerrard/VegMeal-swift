//
//  UserView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/7/20.
//

import SwiftUI



struct UserView: View {
    @EnvironmentObject var userController: UserApolloController
    let onClose: () -> ()
    var pct: CGFloat
    @State private var showingAlert = false
    @Binding var showModal: Bool

    
    var body: some View {

        
                VStack(alignment: .leading) {
                    HStack {
                        Text("Account").font(.largeTitle).fontWeight(.bold).padding()
                        Spacer()
                        CloseButton().onTapGesture {
                            onClose()
                        }.padding(.trailing)
                    }.background(Color.secondary).foregroundColor(.white)
        
                    Text("\(userController.loggedInUser?.name ?? "No name")").font(.largeTitle).padding(.horizontal)
                    Text("\(userController.loggedInUser?.email ?? "No email")").font(.title).padding(.horizontal).foregroundColor(.gray)
        
        
                    HStack {
                        Text("Following").font(.largeTitle).fontWeight(.bold).padding()
                        Spacer()
                    }.background(Color.secondary).foregroundColor(.white)
        
                    if userController.getUsersQueryRunning {
                        ProgressView()
                            .padding(.leading)
                            .padding(.bottom)
                    } else {
                        if self.userController.loggedInUser != nil {
        
                            ForEach(0 ..< userController.otherUsers.count) { index in
                                isFollowingToggle(otherUser: $userController.otherUsers[index], currentUser: self.userController.loggedInUser!)
                            }
                        }
                    }
        
                    Spacer()
        
                    HStack {
                        Button(action: {
                            self.showingAlert.toggle()
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity).font(.title).padding(.bottom, 50).accentColor(.red)
                        }
                    }
        
        
                }.onAppear{
                    userController.getUsersQueryRunning = true
                    userController.getUsers()
                }
                .background(Color.white)
                .alert(isPresented:$showingAlert) {
                    Alert(title: Text("Are you sure you want to logout?"), message: Text("Logout?"), primaryButton: .destructive(Text("Logout")) {
                        self.userController.logUserOut()
                        self.showModal.toggle()
                        onClose()
        
                    }, secondaryButton: .cancel())
                }
        
    }
    
}


struct isFollowingToggle: View {
    @EnvironmentObject var userController: UserApolloController
    
    @Binding var otherUser: OtherUser
    var currentUser: UserFragment
    
    var body: some View {
        Checkbox(id: otherUser.id, label: "\(otherUser.name): \(otherUser.email)", size: 22, callback: checkboxSelected, isMarked: $otherUser.isFollowing).padding()
        
    }
    
    func checkboxSelected(id: String, isMarked: Bool) {
        // Since ismarked is bound to model, array of followers updates automatically, and below updates server with API call
        // If there is an error in API call, that could be an issue.
        if isMarked {
            userController.startFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
        } else {
            userController.stopFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
        }
        print("\(id) is marked: \(isMarked)")
    }
}



struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(onClose: {print("Huh?")}, pct: 1, showModal: .constant(true))
            .environmentObject(UserApolloController())
        
    }
}
