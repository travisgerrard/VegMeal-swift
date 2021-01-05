//
//  ModalViewSimplified.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/4/21.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct ModalViewSimplified: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    @EnvironmentObject var groceryListController: GroceryListApolloController
    @EnvironmentObject var mealListController: MealListApolloController
    @State var meal: MealFragment
    let pictureSize = CGSize(width: screen.width, height: 375)
    var pct: CGFloat = 1
    @State private var showEditMealModal: Bool = false
    @State var showingMealAddedAlert: Bool = false
    @State var addMealAgainAlert: Bool = false
    @AppStorage("userid") var userId = ""
    
    var body: some View {
        return GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack {
                        KFImage(parse(object: meal),
                                options: [
                                    .transition(.fade(0.2)),
                                    .processor(
                                        DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
                                    ),
                                    .cacheOriginalImage
                                ])
                            .placeholder {
                                HStack {
                                    Image("009-eggplant")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(10)
                                    Text("Loading...").font(.title)
                                }
                                .foregroundColor(.gray)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: UIScreen.main.bounds.size.width)
                            .frame(height: 375)
                            .overlay(
                                VStack{
                                    HStack {
                                        Text(meal.name ?? "No name")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .minimumScaleFactor(0.5)
                                            .padding(.leading)
                                            .padding(.top)
                                            .padding(.bottom, 1)
                                        
                                        Spacer()
                                    }
                                    HStack {
                                        Text(meal.description ?? "No description")
                                            .font(.subheadline)
                                            .padding(.leading)
                                            .padding(.bottom, 5)
                                        
                                        Spacer()
                                    }
                                    HStack {
                                        if self.mealListController.mealList.contains(where: { $0.meal.id == meal.id }) {
                                            Button("On Grocery List", action: {
                                                addMealAgainAlert.toggle()
                                            })
                                            .font(.callout)
                                            .padding(.leading)
                                            .padding(.bottom)
                                            
                                            
                                        } else {
                                            Button("Add To Grocery List", action: {
                                                self.networkingController.addMealToGroceryList(mealId: meal.id, userId: userId, groceryListController: self.groceryListController, mealListController: self.mealListController)
                                                
                                            })
                                            .font(.callout)
                                            .padding(.leading)
                                            .padding(.bottom)
                                            
                                        }
                                        
                                        if self.networkingController.addingMealToGroceryListIsLoading {
                                            ProgressView().onDisappear {
                                                showingMealAddedAlert.toggle()
                                            }
                                        }
                                        Spacer()
                                        if userId == meal.author!.id {
                                            Button("Edit", action: {showEditMealModal.toggle()})
                                                .font(.callout)
                                                .padding(.trailing)
                                                .padding(.bottom)
                                                .sheet(isPresented: $showEditMealModal, onDismiss: {}) {
                                                    AddMealView(isEditingMeal: true, url: parse(object: meal), mealId: meal.id, name: meal.name!, description: meal.description!, showModal: self.$showEditMealModal)
                                                        .environmentObject(self.networkingController)
                                                }
                                        }
                                        
                                    }
                                }.background(BlurView(style: .systemMaterial))
                                , alignment: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                            .frame(width: (pictureSize.width - proxy.size.width) * pct + proxy.size.width,
                                   height: (pictureSize.height - proxy.size.height) * pct + proxy.size.height)
                        
                        
                    }
                    .alert(isPresented: $showingMealAddedAlert) {
                        Alert(title: Text("Meal added"), message: Text("Meal added to planner and ingredients added to grocery list"), dismissButton: .default(Text("Got it!")))
                    }
                    
                    
                    ListOfIngredients(ingredientList: $meal.ingredientList, didCreateMeal: (userId == meal.author!.id), mealId: meal.id)
                    
                    VStack {
                        VStack() {
                            if userId == meal.author!.id {
                                AddIngredients(mealId: meal.id).zIndex(10)
                            }
                            
                            VStack {
                                Divider().background(Color.black)
                                MealLogView(mealId: meal.id, authorId: userId)
                            }.offset(y: userId == meal.author!.id ? -320 : -9).zIndex(9)
                            
                        }
                    }
                    .alert(isPresented: $addMealAgainAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Are you sure you want to add thsi meal to your planner multiple times?"), primaryButton: .default(Text("Yes")) {
                            self.networkingController.addMealToGroceryList(mealId: meal.id, userId: userId, groceryListController: self.groceryListController, mealListController: self.mealListController)
                        }, secondaryButton: .cancel())
                    }
                    
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationTitle(meal.name ?? "No name")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
//
//struct ModalViewSimplified_Previews: PreviewProvider {
//    static var previews: some View {
//        ModalViewSimplified()
//    }
//}
