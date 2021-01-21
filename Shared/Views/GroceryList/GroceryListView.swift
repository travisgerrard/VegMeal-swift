//
//  GroceryListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import SwiftUI

struct GroceryListView: View {
    @EnvironmentObject var groceryListController: GroceryListApolloController
        
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""
    
    @State var showCard = false
    @State var show = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    
    @State var category = ""
    @State var groceryListIndex = 999
    
    @State var sectionName = ""
    
    static let tag: String? = "GroceryListView"

      
    var body: some View {

        if isLogged {
            ZStack {
                VStack {
                    NavigationView {
                        GroceryListSubView(groceryListController: self.groceryListController)
                    }
                }
                
                
                VStack {
                    HStack {
                        if self.groceryListController.groceryListQueryRunning {
                            ProgressView().padding(.leading).padding(.all, 10)
                            
                            
                        } else {
                            Button(action: {
                                self.groceryListController.getGroceryList(userId: userid)
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
                                hideKeyboard()
                                bottomState = .zero
                            }
                        }
                        )
                }
                .edgesIgnoringSafeArea(.all)
            }
        } else {
            LoginInCreateAccountPromt()
        }
        
        
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
            .environmentObject(GroceryListApolloController())
    }
}

struct BottomCardView: View {
    @Binding var show: Bool
    @Binding var bottomState: CGSize
    
    var body: some View {
        
        VStack(spacing: 20) {
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

struct GroceryListSubView: View {
    var groceryListController: GroceryListApolloController
    @AppStorage("userid") var userid = ""
    @State var completeIsPressed = false

    var body: some View {
        List {
            Text("Temp")
//            ForEach(0..<11) { index in
////                // If the current grocery list has an ingredient with specific category, show catergory as seciton header
//                if self.groceryListController.groceryList.contains(where: {$0.ingredient?.category == index}) {
//                    Section(header: Text("\(self.groceryListController.groceryList[0].options[index] ?? "no value")")) {
//                        ForEach(0..<self.groceryListController.groceryList.count, id: \.self) {i in
//                            if self.groceryListController.groceryList[i].ingredient?.category == index {
//
//                                GroceryListCellView(
//                                    groceryListController: groceryListController,
//                                    groceryList: self.groceryListController.groceryList,
//                                    i: i,
//                                    isCompleted: false
//                                )
//
//                            }
//                        }
//                    }
//                }
//
////            }
//
//            Section(header: Text("Completed")) {
//                ForEach(0..<self.groceryListController.completedGroceryList.count, id: \.self) {i in
//
//                    GroceryListCellView(
//                        groceryListController: groceryListController,
//                        groceryList: self.groceryListController.completedGroceryList,
//                        i: i,
//                        isCompleted: true
//                    )
//
//                }
//            }
        }
        
        .navigationBarTitle("Grocery List")
        .onAppear {
            self.groceryListController.getGroceryList(userId: userid)
        }
    }
}

struct GroceryListCellView: View {
    var groceryListController: GroceryListApolloController
    var groceryList: [GroceryListFragment]

    var i: Int
    @State var completeIsPressed = false
    var isCompleted: Bool

    var body: some View {
        HStack {
            Button(action: {
            }) {
                Circle()
                    .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                    .frame(width: 32, height: 32)
                    .foregroundColor(isCompleted ? .gray : .white)
                    .padding(.trailing, 3)
            }
            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                        .onChanged { _ in
                            completeIsPressed = true
                        }
                        .onEnded { _ in
                            self.groceryListController.completeGroceryListItem(id: groceryList[i].id)
                            completeIsPressed = false
                        }
            )
            
            VStack(alignment: .leading) {
                Text("\(groceryList[i].ingredient?.fragments.ingredientFragment.name ?? "No ingredient") - \(groceryList[i].amount?.fragments.amountFragment.name ?? "No amount")")
                if isCompleted && groceryList[i].dateCompletedFormatted != nil {
                    Text("Completed \(groceryList[i].dateCompletedFormatted!, style: .relative) ago").font(.caption)
                } else {
                    Text("Completed just now").font(.caption)
                }
                if groceryList[i].meal?.fragments.mealDemoFragment.name != nil {
                    Text("\((groceryList[i].meal?.fragments.mealDemoFragment.name)!)").font(.footnote).italic()
                }
            }.foregroundColor(isCompleted ? .gray : .black)
            
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
                            self.groceryListController.deleteGroceryListItem(id: groceryList[i].id)
                        }
            )
            
        }
    }
}
