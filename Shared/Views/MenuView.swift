//
//  MenuView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var user: UserStore
    @Binding var showProfile: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text(user.email)
                    .font(.caption)
                Text(user.userid)
                    .font(.caption)
                
                MenuRow(title: "Sign out", icon: "person.crop.circle")
                    .onTapGesture(count: 1, perform: {
                        UserDefaults.standard.set(false, forKey: "isLogged")
                        user.isLogged = false
                        
                        UserDefaults.standard.set("", forKey: "token")
                        user.token = ""
                        showProfile = false
                    })
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            
        }
        .padding(.bottom, 30)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showProfile: .constant(true)).environmentObject(UserStore())
    }
}

struct MenuRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .light))
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
            
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .frame(width: 120, alignment: .leading)
        }
    }
}
