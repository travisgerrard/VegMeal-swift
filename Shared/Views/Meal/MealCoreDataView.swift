//
//  MealCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/13/21.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MealCoreDataView: View {
    var meal: MealDemo
    let pictureSize = CGSize(width: screen.width, height: 375)
    @AppStorage("userid") var userId = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showEditMealModal: Bool = false
    
    func addMealToGroceryList() {
        let mutation = AddMealToGroceryListMutation(mealId: meal.idString, authorId: userId)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResult):
                print("????")
                if let data = graphQLResult.data {
                    if let addMealToGroceryList = data.addMealToGroceryList {
                        print(addMealToGroceryList)
                    }
                    if let addMealToMealList = data.addMealToMealList {
                        print(addMealToMealList)
                    }
                }
            }
        }
    }
    
    var body: some View {
        return GeometryReader { proxy in
            
            ZStack {
                ScrollView {
                    VStack {
                        KFImage(meal.mealImageUrl,
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
                            .frame(height: 400)
                            .overlay(
                                VStack {
                                    HStack {
                                        Text(meal.mealName)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .minimumScaleFactor(0.5)
                                            .padding(.leading)
                                            .padding(.top)
                                            .padding(.bottom, 1)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(meal.mealDetail)
                                            .font(.subheadline)
                                            .padding(.leading)
                                            .padding(.bottom, 5)
                                        
                                        Spacer()
                                    }
                                    HStack {
                                        if userId != "" {
                                            
                                            Button(action: {
                                                addMealToGroceryList()
                                            }) {
                                                Image(systemName: "cart.badge.plus")
                                                Text("/")
                                                Image(systemName: "folder.badge.plus")
                                            }
                                            .font(.callout)
                                            .padding(.leading)
                                            .padding(.bottom)
                                            
                                            
                                        }
                                        Spacer()
                                        if userId == meal.mealAuthor {
                                            Button("Edit", action: {showEditMealModal.toggle()})
                                                .font(.callout)
                                                .padding(.trailing)
                                                .padding(.bottom)
                                                .sheet(isPresented: $showEditMealModal, onDismiss: {}) {
                                                    AddMealCoreDataView(isEditingMeal: true, showModal: self.$showEditMealModal, meal: meal)
                                                }
                                        }
                                    }
                                }.background(BlurView(style: .systemMaterial))
                                , alignment: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                            .frame(width: (pictureSize.width - proxy.size.width) + proxy.size.width,
                                   height: (pictureSize.height - proxy.size.height/10))
                        
                        ListOfMealIngredientsCoreDataView(ingredientList: meal.mealIngredientListDemoArray)
                        if userId != "" {
                            VStack {
                                //                                Divider().background(Color.black)
                                MealLogCoreDataView(meal: meal)
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct MealCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealCoreDataView()
//    }
//}
