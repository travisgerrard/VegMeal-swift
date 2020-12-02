//
//  MealLogApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/23/20.
//


import Apollo
import Combine
import SwiftUI

class MealLogApolloController: ObservableObject {
    @Published var mealLogList: [MadeMealFragment] = []
    @Published var mealLogListQueryRunning: Bool = false
    @Published var mealLogListQueryError: Error?
    
    func getMealLogList(mealId: String, authorId: String) {
        self.mealLogListQueryRunning = true
        let query = GetMadeMealsQuery(mealId: mealId, authorId: authorId)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            self.mealLogListQueryRunning = false
            switch result {
            case .failure(let error):
                self.mealLogListQueryError = error
                
            case .success(let graphQLResults):
//                print("Success: \(graphQLResults)")
                guard let returnedMealLogs = graphQLResults.data?.allMadeMeals else { break }
                
                self.mealLogList.removeAll()
                
                for mealLog in returnedMealLogs {
//                    print(mealLog!.fragments.madeMealFragment)
                    self.mealLogList.append(mealLog!.fragments.madeMealFragment)
                }
            }
        }
    }
    
    func updateMealLog(id: String, thoughts: String, dateMade: Date) {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let formatter3 = iso8601DateFormatter.string(from: dateMade)
        
//        print("id: \(id), thoughts: \(thoughts), dateMade: \(formatter3)")
        
        let mutation = UpdateMadeMealMutation(id: id, thoughts: thoughts, dateMade: formatter3)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                
            }
            
        }
    }
    
    func deleteMealLog(id: String) {
        let mutation = DeleteMadeMealMutation(id: id)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
//                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    return
                }
                
                if let mealLogToDeleteIndex = self.mealLogList.firstIndex(where: {$0.id == id}) {
                    self.mealLogList.remove(at: mealLogToDeleteIndex)
                }
            }
            
        }
    }
    
    func addMealLog(mealId: String, authorId: String) {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let formatter3 = iso8601DateFormatter.string(from: Date())
        
    let mutation = MadeMealMutation(mealId: mealId, authorId: authorId, dateMade: formatter3)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
//                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    return
                }
                
                guard let mealLogToAdd = graphQLResults.data?.createMadeMeal?.fragments.madeMealFragment else { break }
                self.mealLogList.insert(mealLogToAdd, at: 0)
            }
            
        }
    }
}
