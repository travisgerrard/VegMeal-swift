//
//  ModalView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/30/20.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct ModalView: View {
    let id: String
    @Binding var meal: MealFragment
    var pct: CGFloat
    var flyingFromGrid: Bool
    var userId: String? = nil
    
    let onClose: () -> ()
    
    var body: some View {
        // We use EmptyView, because the modifier actually ignores
        // the value passed to its body() function.
        EmptyView().modifier(ModalMod(userId: userId, meal: $meal, pct: pct, flyingFromGrid: flyingFromGrid, onClose: onClose))
    }
}

struct ModalMod: AnimatableModifier {
    @EnvironmentObject var networkingController: ApolloNetworkingController     //Get the networking controller from the environment objects.
    
    
    @Environment(\.colorScheme) var scheme
    
    @Environment(\.gridRadiusPct) var gridRadiusPct: CGFloat
    @Environment(\.gridShadow) var gridShadow: CGFloat
    @Environment(\.favRadiusPct) var favRadiusPct: CGFloat
    @Environment(\.favShadow) var favShadow: CGFloat
    
    let userId: String?
    @Binding var meal: MealFragment
    var pct: CGFloat
    var flyingFromGrid: Bool
    let pictureSize = CGSize(width: screen.width, height: 375)
    @State var isAddIngredientsOpen = false
    let onClose: () -> ()
    @State private var showEditMealModal: Bool = false

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func parse(object: MealFragment) -> URL {
        guard let mealImage = object.mealImage?.publicUrlTransformed else { return URL(string: "")! }
        
        return URL(string: mealImage)!
    }
    
    
    func body(content: Content) -> some View {
        
        return GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack {
                        KFImage(self.parse(object: meal),
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
                                        if userId != nil {
                                            Button("Add To Grocery List", action: {
                                                self.networkingController.addMealToGroceryList(mealId: meal.id, userId: userId!)
                                            })
                                            .font(.callout)
                                            .padding(.leading)
                                            .padding(.bottom)
                                        }
                                        if self.networkingController.addingMealToGroceryListIsLoading {
                                            ProgressView()
                                        }
                                        Spacer()
                                        if userId != nil ? userId == meal.author!.id : false {
                                            Button("Edit", action: {showEditMealModal.toggle()})
                                                .font(.callout)
                                                .padding(.trailing)
                                                .padding(.bottom)
                                                .sheet(isPresented: $showEditMealModal, onDismiss: {}) {
                                                    AddMealView(isEditingMeal: true, url: self.parse(object: meal), mealId: meal.id, name: meal.name!, description: meal.description!, showModal: self.$showEditMealModal)
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
                    
                    ListOfIngredients(ingredientList: $meal.ingredientList, didCreateMeal:  (userId != nil ? userId == meal.author!.id : false), mealId: meal.id)
                    
                    VStack {
                        VStack() {
                            if userId != nil ? userId == meal.author!.id : false {
                                AddIngredients(mealId: meal.id).zIndex(10)
                            }
                            
                            if userId != nil {
                                VStack {
                                    Divider().background(Color.black)
                                    MealLogView(mealId: meal.id, authorId: userId!)
                                }.offset(y: userId == meal.author!.id ? -320 : -9).zIndex(9)
                            }
                        }
                    }
                    
                    
                }
                .overlay(CloseButton(onTap: onClose).opacity(Double(pct)), alignment: .topTrailing)
                .edgesIgnoringSafeArea(.all)
            }
        }
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
                .padding(40)
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    
    static var previews: some View {
        ModalView(id: "5f4c7bfdf818ca3c74eb7d6d", meal: .constant(MealFragment(id: "5f4c7bfdf818ca3c74eb7d6d", name: "Test", description: "Text description", mealImage: MealFragment.MealImage(publicUrlTransformed: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg"), author: MealFragment.Author(id: "1"), ingredientList: [
                                                                                MealFragment.IngredientList(
                                                                                    id: "1",
                                                                                    ingredient:
                                                                                        MealFragment.IngredientList.Ingredient(
                                                                                            id: "1",
                                                                                            name: "butternut squash"),
                                                                                    amount:
                                                                                        MealFragment.IngredientList.Amount(
                                                                                            id: "1",
                                                                                            name: "1 & 1/2 cups")
                                                                                ),
                                                                                MealFragment.IngredientList(
                                                                                    id: "2",
                                                                                    ingredient:
                                                                                        MealFragment.IngredientList.Ingredient(
                                                                                            id: "2",
                                                                                            name: "olive oil"),
                                                                                    amount:
                                                                                        MealFragment.IngredientList.Amount(
                                                                                            id: "2",
                                                                                            name: "2 tbsp")
                                                                                ),
                                                                                MealFragment.IngredientList(
                                                                                    id: "3",
                                                                                    ingredient:
                                                                                        MealFragment.IngredientList.Ingredient(
                                                                                            id: "3",
                                                                                            name: "salt"),
                                                                                    amount:
                                                                                        MealFragment.IngredientList.Amount(
                                                                                            id: "3",
                                                                                            name: "2 tsp")
                                                                                )])), pct: 1, flyingFromGrid: true, userId: "5f4c7b0cf818ca3c74eb7d6b", onClose: {})
            .environmentObject(ApolloNetworkingController())
            .environmentObject(MealLogApolloController())
    }
}


