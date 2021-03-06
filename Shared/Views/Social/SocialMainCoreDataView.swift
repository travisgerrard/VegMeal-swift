//
//  SocialMainCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/27/21.
//

import SwiftUI

struct SocialMainCoreDataView: View {
    @EnvironmentObject var userController: UserApolloController
    @EnvironmentObject var socialController: SocialApolloController
    @EnvironmentObject var networkingController: ApolloNetworkingController
    
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
    
    @FetchRequest(
        entity: MealDemo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MealDemo.createdAt, ascending: false)]
    ) var meals: FetchedResults<MealDemo>

    // Even though we wont be reading from this FetchRequest in this
    @FetchRequest(
        entity: MadeMeal.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MadeMeal.dateMade, ascending: false)]
    ) var thoughts: FetchedResults<MadeMeal>
   
    let currentUser: FetchRequest<UserDemo>

    init(userid: String) {

        currentUser = FetchRequest<UserDemo>(
            entity: UserDemo.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \UserDemo.name, ascending: false)
            ],
            predicate: NSPredicate(format: "idString = %@", userid))
 
        self.userid = userid
    }
    @Environment(\.managedObjectContext) var managedObjectContext

    
    static let tag: String? = "SocialView"
    
    func loadSocialViewData() {
        var arrayOfFollwerId: [String] = []

        if !currentUser.wrappedValue.isEmpty {
            let singleCurrentUser = currentUser.wrappedValue[0]
            
            singleCurrentUser.follows?.forEach {
                let user = $0 as? UserDemo
                if user != nil {
                    arrayOfFollwerId.append(user!.idString)
                }
            }
            
            let query = AllMealsQuerySocialQuery(ids: [userid] + arrayOfFollwerId)
            ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in

                
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let graphQLResults):
    //                guard let mostRecentMeals = graphQLResults.data?.allMeals else { break }
                    guard let allMadeMeals = graphQLResults.data?.allMadeMeals else { break }
                    
                    for madeMeal in allMadeMeals {
                        if let madeMealFragment = madeMeal?.fragments.madeMealFragment {

                            // Load made meal into DB
                            let madeMealDB = MadeMeal.object(in: managedObjectContext, withFragment: madeMealFragment)
                            
                            if let mealDemoFragment = madeMealFragment.meal?.fragments.mealDemoFragment {
                                let mealDB = MealDemo.object(in: managedObjectContext, withFragment: mealDemoFragment)
                                madeMealDB?.meal = mealDB
                            }
                        }
                    }
                    try? managedObjectContext.save()
                    
                }
            }
        }
        
    }
    
    var body: some View {
        if isLogged {
            ZStack{
                
                
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Recently Added Meals")
                                .font(.headline)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                LazyHStack {
                                    ForEach(meals) { meal in
                                        NavigationLink(destination: MealCoreDataView(meal: meal)) {
                                            RecentlyAddedSocialMealView(meal: meal)
                                        }.buttonStyle(FlatLinkStyle())
                                    }
                                }.frame(height: 300)
                            }
                            Text("Recently Commented Meals")
                                .font(.headline)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack(alignment: .center) {
                                    ForEach(thoughts) { mealLog in
                                        NavigationLink(destination: MealCoreDataView(meal: mealLog.meal!)) {
                                            
                                            RecentlyCommentedSocialMealView(mealLog: mealLog)
                                        }.buttonStyle(FlatLinkStyle())
                                    }
                                }
                            }
                        }
                        
                    }
                    .navigationTitle("Social")
                    .onAppear {
                        loadSocialViewData()
                    }
                }.navigationViewStyle(StackNavigationViewStyle())
                
            }
            
        } else {
            LoginInCreateAccountPromt()
        }
    }
    
    struct FlatLinkStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
        }
    }
}
//
// struct SocialMainView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SocialMainView()
//            .environmentObject(UserApolloController())
//            .environmentObject(SocialApolloController())
//    }
// }
//
