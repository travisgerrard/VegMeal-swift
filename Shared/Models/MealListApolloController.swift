//
//  MealListApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/23/20.
//

import Apollo
import Combine
import SwiftUI

struct MealListItem: Identifiable {
    var id: String
    var isCompleted: Bool
    var meal: MealFragment
}

class  MealListApolloController: ObservableObject {
    @Published var mealList: [MealListItem] = []
    @Published var mealListQueryRunning: Bool = false
    @Published var mealListQueryError: Error?

    func getMealList(userId: String) {
        mealListQueryRunning = true
        let query = MyMealsQueryQuery(authorId: userId)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            self.mealListQueryRunning = false
            switch result {
            case .failure(let error):
                self.mealListQueryError = error
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                guard let returnedMealList = graphQLResults.data?.allMealLists else { break }
                self.mealList.removeAll()
                for meal in returnedMealList {
                    self.mealList.append(MealListItem(id: meal!.id!, isCompleted: meal!.isCompleted!, meal: meal!.meal!.fragments.mealFragment))
                }
            }
        }
    }
    
    func deleteMealListItem(id: String) {
        let mutation = DeleteMyMealListItemMutation(id: id)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    return
                }
                if let mealListToDeleteIndex = self.mealList.firstIndex(where: {$0.id == id}) {
                    self.mealList.remove(at: mealListToDeleteIndex)
                }
            }
        }
    }
    
    func completeMealListItem(id: String) {
        let today = Date()
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formatter3 = iso8601DateFormatter.string(from: today)
        
        let mutation = CompleteMyMealMutation(id: id, dateCompleted: formatter3)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                if let error = graphQLResults.errors {
                    print(error)
                    return
                }
                if let mealListToDeleteIndex = self.mealList.firstIndex(where: {$0.id == id}) {
                    self.mealList.remove(at: mealListToDeleteIndex)
                }
            }
        }
    }
}

