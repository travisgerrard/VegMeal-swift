//
//  MealLogCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/16/21.
//

import SwiftUI
import CoreData

struct MealLogCoreDataView: View {
    var meal: MealDemo
    let mealLogs: FetchRequest<MadeMeal>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userController: UserApolloController
    
    @AppStorage("userid", store: UserDefaults.shared) var userId = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    init(meal: MealDemo) {
        mealLogs = FetchRequest<MadeMeal>(
            entity: MadeMeal.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MadeMeal.dateMade, ascending: false)
            ],
            // Only look for made meals for current meal
            // Will need to add in option for author...
            predicate: NSPredicate(format: "meal = %@", meal))
        
        self.meal = meal
        
    }
    
    func getMealLogFor(followers: [OtherUser]) {
        var arrayOfFollwerId: [String] = []
        
        for follower in followers {
            arrayOfFollwerId.append(follower.id)
        }
        
        let query = GetMadeMealsQuery(ids: [userId] + arrayOfFollwerId, mealId: meal.idString)
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
                        try? managedObjectContext.save()
                    }
                }
            }
        }
    }
    
    func addLogToMealLog() {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let formatter3 = iso8601DateFormatter.string(from: Date())
        
        let mutation = MadeMealMutation(mealId: meal.idString, authorId: userId, dateMade: formatter3)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                managedObjectContext.undo()
                
            case .success(let graphQLResults):
                //                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    managedObjectContext.undo()

                    return
                }
                
                // Save deletion
                
                guard let mealLogToAdd = graphQLResults.data?.createMadeMeal?.fragments.madeMealFragment else { break }
                let madeMealDB = MadeMeal.object(in: managedObjectContext, withFragment: mealLogToAdd)
                madeMealDB?.meal = meal
                try? managedObjectContext.save()

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
                        addLogToMealLog()
                    }
                }).padding(.trailing)
            }
            ForEach(mealLogs.wrappedValue) { mealLog in
                MealLogCoreData(mealLog: mealLog)
            }
            Spacer()
            
        }
        .onAppear {
            self.getMealLogFor(followers: self.userController.followingUsers)
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
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
    @State var thoughts: String
    @State var mealLogDate: Date
    
    @State private var showingDeleteMealAlert = false
    
    var placeholderString = "Thoughts on meal and life?"

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var userController: UserApolloController
    
    init(mealLog: MadeMeal) {
        self.mealLog = mealLog
        
        _thoughts = State(wrappedValue: mealLog.mealThoughts)
        _mealLogDate = State(wrappedValue: mealLog.mealDateMade)
    }
    
    func deleteLogFromMealLog(mealLog: MadeMeal) {
        let mutation = DeleteMadeMealMutation(id: mealLog.idString)
        
        managedObjectContext.delete(mealLog)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
                managedObjectContext.undo()

            // Should undo coredata deletion...

            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print("Error/Success: \(error)")
                    managedObjectContext.undo()

                    return
                }
                
                // Save deletion
                try? managedObjectContext.save()
            }
            
        }
    }
    
    func updateMealLog(mealLog: MadeMeal, thoughts: String, dateMade: Date) {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let formatter3 = iso8601DateFormatter.string(from: dateMade)
        
        mealLog.thoughts = thoughts
        mealLog.dateMade = dateMade
        
        let mutation = UpdateMadeMealMutation(id: mealLog.idString, thoughts: thoughts, dateMade: formatter3)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                managedObjectContext.undo()

            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    managedObjectContext.undo()

                    return
                }
                try? managedObjectContext.save()
                
            }
            
        }
    }
    
    var body: some View {
        if isEditingMealLog {
            VStack {
                HStack {
                    
                    DatePicker(selection: $mealLogDate, in: ...Date(), displayedComponents: .date) {
                        Text("You made this meal on:")
                        
                    }
                    Spacer()
                }.padding()
                TextEditor(text: $thoughts)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(mealLog.mealThoughts == placeholderString && thoughts == placeholderString ? .gray : .primary)
                    .onTapGesture {
                        if mealLog.mealThoughts == placeholderString {
                            if self.thoughts == placeholderString {
                                self.thoughts = ""
                            }
                        } else {
                            self.thoughts = mealLog.mealThoughts
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal)
                
                
                Spacer()
                HStack {
                    Button("Save", action: {
                        withAnimation(.spring()) {
                            // Save comment
                            updateMealLog(mealLog: mealLog, thoughts: thoughts, dateMade: mealLogDate)
                            self.isEditingMealLog.toggle()
                        }
                    }).padding(.trailing)
                    Button("Cancel", action: {
                        withAnimation(.spring()) {
                            thoughts = mealLog.mealThoughts
                            mealLogDate = mealLog.mealDateMade
                            self.isEditingMealLog.toggle()
                        }
                    }).padding(.trailing)
                    Button(action: {
                        withAnimation(.spring()) {
                            // Delete this meal log
                            // Should add in alert here...
                            print("Pressed this button")
                            self.showingDeleteMealAlert.toggle()
                        }
                    }, label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    })
                    .alert(isPresented: $showingDeleteMealAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("Are you sure you want to delete this log entry?"),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteLogFromMealLog(mealLog: mealLog)
                                self.isEditingMealLog.toggle()

                            },
                            secondaryButton: .cancel())
                    }
                    
                    Spacer()
                }.padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .onAppear {
                //                thoughtsDefault = thoughts
                //                mealLogDateDeafult = mealLogDate
            }
        } else {
            VStack {
                HStack {
                    Text("\((mealLog.thoughtsAuthorId == userid ? "You" : "\(mealLog.thoughtsAuthorName)")) made this meal on: \(dateFormatter.string(from: mealLog.mealDateMade))")
                    Spacer()
                }
                if mealLog.mealThoughts != "Thoughts on meal and life?" {
                    VStack {
                        if mealLog.thoughtsAuthorId == userid {
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
                                Text(mealLog.mealThoughts)
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
                    if mealLog.thoughtsAuthorId == userid {
                        
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
