//
//  LoginView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/7/20.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showAlert = false
    @State var alertMessage = "Something went wrong"
    @State var isLoading = false
    @State var isSuccessful = false
    @State var viewState = CGSize.zero
    @State var show = false
    @State private var keyboardHeight: CGFloat = 0
    
    @EnvironmentObject var user: UserStore
    
    func login() {
        hideKeyboard()
        isFocused = false
        isLoading = true
        
        ApolloController.shared.apollo.perform(mutation: AuthenticateUserMutation(email: email, password: password)) { result in
            isLoading = false
            
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    if let authenticateUserWithPassword = data.authenticateUserWithPassword {
                        if let token = authenticateUserWithPassword.token {
                            
                            self.user.token = token
                            UserDefaults.standard.set(token, forKey: "token")
                        }
                        if let item = authenticateUserWithPassword.item {
                            self.user.email = item.email!
                            UserDefaults.standard.set(item.email!, forKey: "email")
                            
                            self.user.userid = item.id
                            UserDefaults.standard.set(item.id, forKey: "userid")
                            
                        }
                        isSuccessful = true
                        
                        self.user.isLogged = true
                        UserDefaults.standard.set(true, forKey: "isLogged")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSuccessful = false
                            email = ""
                            password = ""
                            user.showLogin = false
                        }
                        
                    }
                }
                if let error = graphQLResult.errors?.first {
                    if let message = error.message {
                        showAlert = true
                        alertMessage = message
                    }
                }
                
            case .failure(let error):
                showAlert = true
                alertMessage = error.localizedDescription
                print(error)
                
            }
        }
    }

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

var body: some View {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        VStack {
            ZStack(alignment: .top) {
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    GeometryReader { geometry in
                        Text("Veggily")
                            .font(.system(size: geometry.size.width / 10, weight: .bold))
                            .padding(.leading)
                    }
                    .frame(maxWidth: 375, maxHeight: 100)
                    .padding(.horizontal, 16)
                    //                        .offset(x: viewState.width / 15, y: viewState.height / 15)
                    
                    
                    Text("Come For The Meals, Stay For The Memories")
                        .font(.subheadline)
                        .frame(width: 350)
                    //                            .offset(x: viewState.width / 15, y: viewState.height / 15)
                    
                    Spacer()
                    
                }
                .multilineTextAlignment(.center)
                .padding(.top, 95)
                .frame(height: 477)
                .frame(maxWidth: .infinity)
                .background(
                    Image(uiImage: #imageLiteral(resourceName: "009-eggplant.png"))
                        .offset(x: viewState.width / 25, y: viewState.height / 25).opacity(0.05)
                    , alignment: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                
                
                VStack {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5 )
                            .padding(.leading)
                        
                        TextField("Your Email".uppercased(), text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture(count: 1, perform: {
                                isFocused = true
                            })
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5 )
                            .padding(.leading)
                        
                        SecureField("Password".uppercased(), text: $password)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture(count: 1, perform: {
                                isFocused = true
                            })
                    }
                }
                .frame(height: 136)
                .frame(maxWidth: 712)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                .padding(.horizontal)
                .offset(y: 250)
                
                HStack {
                    Text("Forgot password?")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action: {
                        login()
                    }, label: {
                        Text("Log in").foregroundColor(.black)
                    })
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                    .alert(isPresented: $showAlert)  {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
            }
        }
        .padding(.bottom, keyboardHeight)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        
        .animation(.easeInOut)
        .onTapGesture(count: 1, perform: {
            isFocused = false
            hideKeyboard()
        })
        
        if isLoading {
            Text("Loading...").frame(width: 200, height: 200)
        }
        
        if isSuccessful {
            Text("Success!")
                .font(.title).bold()
                .opacity(show ? 1 : 0)
                .animation(Animation.linear(duration: 1).delay(0.2))
                .padding(.top, 30)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y:30)
                .scaleEffect(show ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                .onAppear {
                    show = true
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(show ? 0.5 : 0))
                .animation(.linear(duration: 0.5))
                .edgesIgnoringSafeArea(.all)
        }
    }
}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
