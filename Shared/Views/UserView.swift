//
//  UserView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/7/20.
//

import SwiftUI



struct UserView: View {
    @EnvironmentObject var userController: UserApolloController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Account").font(.largeTitle).fontWeight(.bold).padding()
                Spacer()
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
                Text("Log Out")
                    .frame(maxWidth: .infinity).font(.title).padding()
            }
        }.onAppear{
            userController.getUsersQueryRunning = true
            userController.getUsers()
        }.background(Color.white)
    }
}

struct isFollowingToggle: View {
    @EnvironmentObject var userController: UserApolloController
    
    @Binding var otherUser: OtherUser
    var currentUser: UserFragment
    
    var body: some View {
        //        let bindingOn = Binding<Bool> (
        //            get: { self.isToggleOn },
        //            set: { newValue in
        //                self.isToggleOn = newValue
        //                if self.isToggleOn {
        //                    userController.startFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
        //                } else {
        //                    userController.stopFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
        //
        //                }
        //            }
        //        )
        
//        return Toggle("\(otherUser.name): \(otherUser.email)", isOn: $otherUser.isFollowing)
//            .padding()
//            .onChange(of: otherUser.isFollowing) { value in
//                if value {
//                    print(value)
//                    userController.startFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
//                } else {
//                    print("not printing value")
//                    userController.stopFollowingUser(id_to_change_following: otherUser.id, current_user: currentUser.id)
//                }
//            }
        Checkbox(id: otherUser.id, label: "\(otherUser.name): \(otherUser.email)", size: 22, callback: checkboxSelected, isMarked: $otherUser.isFollowing).padding()
        
    }
    
    func checkboxSelected(id: String, isMarked: Bool) {
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
        UserView()
    }
}
