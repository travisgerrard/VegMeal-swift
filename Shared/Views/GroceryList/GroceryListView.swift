//
//  GroceryListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

struct GroceryListView: View {
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var groceryListController: GroceryListApolloController
    
    @State var showCard = false
    @State var show = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    
    @State var completeIsPressed = false
    
    var body: some View {
        if user.isLogged {
            ZStack {
                NavigationView {
                    List {
                        ForEach(self.groceryListController.groceryList) {grocery in
                            HStack {
                                Button(action: {
                                }) {
                                    Circle()
                                        .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                                        .frame(width: 32, height: 32)
                                        .padding(.trailing, 3)
                                }
                                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                            .onChanged { _ in
                                                completeIsPressed = true
                                            }
                                            .onEnded { _ in
                                                self.groceryListController.completeGroceryListItem(id: grocery.id!)
                                                completeIsPressed = false
                                            }
                                )
                                
                                
                                Text("\(grocery.ingredient?.name ?? "No ingredient") - \(grocery.amount?.name ?? "No amount")")
                                Spacer()
                                Button(action: {
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .gesture(TapGesture()
                                            .onEnded {
                                                self.groceryListController.deleteGroceryListItem(id: grocery.id!)
                                            }
                                )
                                
                            }
                        }
                    }
                    .navigationBarTitle("Grocery List")
                    .onAppear {
                        self.groceryListController.getGroceryList(userId: user.userid)
                    }
                }
                
                
                VStack {
                    HStack {
                        if self.groceryListController.groceryListQueryRunning {
                            ProgressView().padding(.leading).padding(.all, 10)
                            
                            
                        } else {
                            Button(action: {
                                self.groceryListController.getGroceryList(userId: user.userid)
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.all, 10)
                                    .clipShape(Circle())
                            }
                            .padding(.leading)
                        }
                        
                        
                        Spacer()
                        Button(action: {
                            bottomState.height += -600
                            showFull = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 17, weight: .bold))
                                .padding(.all, 10)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                    Spacer()
                }
                
                
                
                GeometryReader { bounds in
                    BottomCardView(show: $showCard, bottomState: $bottomState)
                        .offset(x: 0, y: showCard ? bounds.size.height / 2 :
                                    bounds.size.height)
                        .offset(y: bottomState.height)
                        .blur(radius: show ? 20 : 0)
                        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                        .gesture(DragGesture().onChanged { value in
                            bottomState = value.translation
                            if showFull {
                                bottomState.height += -600
                            }
//                            if bottomState.height < -500 {
//                                bottomState.height = -500
//                            }
                        }
                        .onEnded{ value in
                            if bottomState.height > 50 {
                                showCard = false
                            }
                            if (bottomState.height < -100 && !showFull) || (bottomState.height < -400 && showFull) {
                                bottomState.height = -600
                                showFull = true
                            } else {
                                showFull = false
                                bottomState = .zero
                            }
                        }
                        )
                }
                .edgesIgnoringSafeArea(.all)
            }
        } else {
            Text("Please log in or create an account")
        }


    }
}

struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
            .environmentObject(UserStore())
            .environmentObject(GroceryListApolloController())
    }
}

struct BottomCardView: View {
    @Binding var show: Bool
    @Binding var bottomState: CGSize
    
    var body: some View {
        
        VStack(spacing: 20) {
            //            Text("\(bottomState.height)")
            //            if show {
            //                Text("Show")
            //            }
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3.0)
                .opacity(0.1)
            AddToGroceryListView()
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
        .frame(maxWidth: 712)
        .frame(height: 750)
        .background(BlurView(style: .systemThinMaterial))
        .cornerRadius(30)
        .shadow(radius: 20)
        .frame(maxWidth: .infinity)
        
    }
}