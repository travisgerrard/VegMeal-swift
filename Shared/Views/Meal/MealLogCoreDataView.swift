//
//  MealLogCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/16/21.
//

import SwiftUI

struct MealLogCoreDataView: View {
    var meal: MealDemo
    let mealLogs: FetchRequest<MadeMeal>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userController: UserApolloController
    
    @AppStorage("userid") var userId = ""
    
    init(meal: MealDemo) {
        mealLogs = FetchRequest<MadeMeal>(
            entity: MadeMeal.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MadeMeal.dateMade, ascending: false)
            ])
        
        self.meal = meal
    }
    
    func getMealLogFor(mealId: String, followers: [OtherUser]) {
        var arrayOfFollwerId: [String] = []
        
        for follower in followers {
            arrayOfFollwerId.append(follower.id)
        }
        
        let query = GetMadeMealsQuery(ids: [userId] + arrayOfFollwerId, mealId: mealId)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("???")
                if let data = graphQLResults.data {
                    if let allMadeMeals = data.allMadeMeals {
                        for madeMeal in allMadeMeals {
                            if let madeMealFragment = madeMeal?.fragments.madeMealFragment {
                                
                                // Load made meal into DB
                                let madeMealDB = MadeMeal.object(in: managedObjectContext, withFragment: madeMealFragment)
                                
                                madeMealDB?.meal = meal
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Meal Log")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
                Button("Made", action: {
                    withAnimation(.spring()) {
                        // Add made meal...
                    }
                }).padding(.trailing)
            }
            ForEach(mealLogs.wrappedValue) { mealLog in
                MealLogCoreData(mealLog: mealLog, thoughts: mealLog.mealThoughts)
                //                MealLog(mealLog: mealLog, id: mealLog.id, mealLogDate: dateFormatter.date(from: mealLog.dateMade!)!, thoughts: mealLog.thoughts ?? "Thoughts on meal and life?")
            }
            Spacer()
            
        }
        .onAppear {
            self.getMealLogFor(mealId: meal.idString, followers: self.userController.followingUsers)
            //            mealLogController.getMealLogList(mealId: mealId, authorId: authorId, followers: self.userController.followingUsers)
        }    }
}

//struct MealLogCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealLogCoreDataView()
//    }
//}




struct  MealLogCoreData: View {
    @State var isEditingMealLog = false
    let mealLog: MadeMeal
    @AppStorage("userid") var userid = ""
    @State var thoughts: String
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        if isEditingMealLog {
        } else {
            VStack {
                HStack {
                    Text("\((mealLog.author == userid ? "You" : "Follower")) made this meal on: \(dateFormatter.string(from: mealLog.mealDateMade))")
                    Spacer()
                }
                if thoughts.count > 0 && thoughts != "Thoughts on meal and life?" {
                    VStack {
                        if mealLog.author == userid {
                            HStack {
                                Button("Edit Comment", action: {
                                    withAnimation(.spring()) {
                                        self.isEditingMealLog.toggle()
                                    }
                                })
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Text(thoughts)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.leading)
                                Spacer()
                                
                            }
                            //                            .frame(height: 100)
                            .padding()
                            .background(BlurView(style: .systemMaterial))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                            
                            
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                } else {
                    if mealLog.author! == userid {
                        
                        HStack {
                            Button("Write a Comment", action: {
                                withAnimation(.spring()) {
                                    self.isEditingMealLog.toggle()
                                }
                            })
                            
                            
                            Spacer()
                        }
                    }
                    
                }
            }.padding()
        }
    }
}
