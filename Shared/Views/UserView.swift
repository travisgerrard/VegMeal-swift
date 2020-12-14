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
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("email") var email = ""
    @AppStorage("userid") var userid = ""
    @AppStorage("token") var token = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Account").font(.largeTitle).fontWeight(.bold).padding()
                Spacer()
                CloseButton(onTap: onClose).opacity(Double(pct))
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
                ForEach(0 ..< userController.otherUsers.count) { index in
                    isFollowingToggle(otherUser: $userController.otherUsers[index], currentUser: self.userController.loggedInUser!)
                }
                
            }

            Spacer()
            
            Button(action: {}) {
                
            }
            Button(action: {self.showingAlert = true}) {
                Text("Log Out")
                    .frame(maxWidth: .infinity).font(.title).padding()
            }.alert(isPresented:$showingAlert) {
                Alert(title: Text("Are you sure you want to logout?"), message: Text("Logout?"), primaryButton: .destructive(Text("Logout")) {
                    email = ""
                    userid = ""
                    isLogged = false
                    token = ""
                    onClose()
                }, secondaryButton: .cancel())
            }
        }.onAppear{
//            userController.getUsersQueryRunning = true
//            userController.getUsers()
        }.background(Color.white)

    }
    struct CloseButton: View {
        var onTap: () -> Void
        
        var body: some View {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.secondary)
                .padding(3)
                .onTapGesture(perform: onTap)
                .background(Color.white)
                .clipShape(RectangleToCircle(cornerRadiusPercent: 20))
                .padding(20)
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
        UserView(onClose: {}, pct: 1)
            .environmentObject(UserApolloController())

    }
}
