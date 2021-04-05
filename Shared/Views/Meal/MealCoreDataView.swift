//
//  MealCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/13/21.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor
import CoreData

struct MealCoreDataView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var meal: MealDemo
    let pictureSize = CGSize(width: screen.width, height: 375)
    @AppStorage("userid", store: UserDefaults.shared) var userId = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showEditMealModal: Bool = false
    @State var addMealAgainAlert: Bool = false
    @State var onMealPlanerAlready: Bool = false
    
    func addMealToGroceryList() {

        let mutation = AddMealToGroceryListMutation(mealId: meal.idString, authorId: userId)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResult):
                print("????")
                if let data = graphQLResult.data {

                    // Add grocery list itesms with a new query...
                    let query = GroceryListForMealQuery(mealId: meal.idString, authorId: userId)
                    ApolloController.shared.apollo.fetch(query: query) { resultTwo in
                        switch resultTwo {
                        case .failure(let error):
                            print(error)
                        
                        case .success(let graphQLResultTwo):
                            if let dataTwo = graphQLResultTwo.data {
                                if let allGroceryLists = dataTwo.allGroceryLists {
                                    allGroceryLists.forEach {
                                        
                                        _ = GroceryList.object(in: managedObjectContext, withFragment: $0?.fragments.groceryListFragment)
                    
                                    }
                                }
                            }
                        }
                    }
                    
                    // add
                    if let addMealToMealList = data.addMealToMealList {
                        print(addMealToMealList)
                        let mealListDB = MealList.object(in: managedObjectContext, withFragment: addMealToMealList.fragments.mealListFragment)
                        mealListDB?.meal = meal
                    }
                    onMealPlanerAlready.toggle()

                }
            }
        }
        try? managedObjectContext.save()
        
    }
    
    func isAlreadyOnMealList() {
        let mealListByNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MealList")
        mealListByNameFetch.predicate = NSPredicate(format: "meal == %@ && isCompleted = false", meal)
        
        do {
            let fetchedMealListByMeal = try managedObjectContext.fetch(mealListByNameFetch) as? [MealList] ?? []
            
            if fetchedMealListByMeal.count > 0 {
                onMealPlanerAlready = true
            } else {
                onMealPlanerAlready = false
            }
        }   catch {
            fatalError("Failed to get mealList: \(error)")
            
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
                                        DownsamplingImageProcessor(size: CGSize(width: sizeClass == .compact ? 400 : 700, height: sizeClass == .compact ? 400 : 700))
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
                                            
                                            
                                            
                                            if onMealPlanerAlready {
                                                Button(action: {
                                                    addMealAgainAlert.toggle()
                                                }) {
                                                    Image(systemName: "cart.fill")
                                                    Text("/")
                                                    Image(systemName: "folder.fill")
                                                }
                                                .font(.callout)
                                                .padding(.leading)
                                                .padding(.bottom)
                                                .onAppear {
                                                    isAlreadyOnMealList()
                                                }
                                            } else {
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
                                                .onAppear {
                                                    isAlreadyOnMealList()
                                                }
                                                
                                            }
                                            
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
                            .padding(.top, 80)
                            .frame(width: (pictureSize.width - proxy.size.width) + proxy.size.width,
                                   height: (pictureSize.height - proxy.size.height/10))
                        
                        
                        ListOfMealIngredientsCoreDataView(meal: meal, didCreateMeal: userId == meal.mealAuthor).padding(.top, 36)
                      
                        VStack {
                        if userId != "" {
                            if userId == meal.mealAuthor {
                                AddToGroceryListCoreDataView(meal: meal)
                                    
                            }
                            VStack {
                                if userId == meal.mealAuthor {
                                Divider().background(Color.black)
                                }
                                MealLogCoreDataView(meal: meal)
                            }.padding(.bottom, 150).padding(.top, userId == meal.mealAuthor ? 80 : 0)
                        }
                        }.alert(isPresented: $addMealAgainAlert) {
                            Alert(title: Text("Are you sure?"), message: Text("Are you sure you want to add thsi meal to your planner multiple times?"), primaryButton: .default(Text("Yes")) {
                                // Add meal to meallog again
                                addMealToGroceryList()
                            }, secondaryButton: .cancel())
                        }
                    }
                }
                .navigationBarTitle(Text(meal.mealName), displayMode: .inline)
            }
        }
    }
}

struct MealCoreDataView_Previews: PreviewProvider {

    static var previews: some View {
        MealCoreDataView(meal: MealDemo.example)
    }
}
