//
//  GroceryListApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/17/20.
//

import Apollo
import Combine
import SwiftUI


class GroceryListApolloController: ObservableObject {
    @Published var groceryList: [GroceryListFragment] = []
    @Published var groceryListQueryRunning: Bool = false
    @Published var groceryListQueryError: Error?
    
    func getGroceryList(userId: String) {
        groceryListQueryRunning = true
        let query = GetGroceryListQuery(id: userId)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            self.groceryListQueryRunning = false
            switch result {
            case .failure(let error):
                self.groceryListQueryError = error
                
            case .success(let graphQLResults):
//                print("Success: \(graphQLResults)")
                guard let returnedGroceryList = graphQLResults.data?.groceryToComplete else { break }
                self.groceryList.removeAll()
                for grocery in returnedGroceryList {
                    print(grocery!.fragments.groceryListFragment)
                    self.groceryList.append(grocery!.fragments.groceryListFragment)
                }
            }
        }
    }
    
    @Published var addIngredientToGroceryListMutationRunning: Bool = false
    @Published var addIngredientToGroceryListMutationError: Error?
    
    func addIngredientToGroceryList(ingredient: String, amount: String) {
        addIngredientToGroceryListMutationRunning = true
        let mutation = AddGroceryListMutation(ingredient: ingredient, amount: amount)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            self.addIngredientToGroceryListMutationRunning = false
            switch result {
            case .failure(let error):
                self.addIngredientToGroceryListMutationError = error
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                guard let groceryListId = graphQLResults.data?.addGroceryList else { break }
                
                let query = GetGroceryListItemQuery(id: groceryListId.id!)
                ApolloController.shared.apollo.fetch(query: query) { result in
                    switch result {
                    case .failure(let error):
                        self.addIngredientToGroceryListMutationError = error
                        
                    case .success(let graphQLResultTwo):
                        print("Success: \(graphQLResultTwo)")
                        
                        guard let itemArray = graphQLResultTwo.data?.allGroceryLists else { break }
                        let item = itemArray[0]!.fragments.groceryListFragment
                        
                        self.groceryList.insert(item , at: 0)
                    }
                }
            }
        }
    }
    
    func deleteGroceryListItem(id: String) {
        let mutation = DeleteGroceryListItemMutation(id: id)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
                print("Success: \(graphQLResults)")
                if let groceryListToDeleteIndex = self.groceryList.firstIndex(where: {$0.id == id}) {
                    self.groceryList.remove(at: groceryListToDeleteIndex)
                }
            }
        }
    }
    
    func completeGroceryListItem(id: String) {
        let today = Date()
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formatter3 = iso8601DateFormatter.string(from: today)
        
        let mutation = CompleteGroceryListMutation(id: id, dateCompleted: formatter3, isCompleted: true)
        
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
                if let groceryListToDeleteIndex = self.groceryList.firstIndex(where: {$0.id == id}) {
                    self.groceryList.remove(at: groceryListToDeleteIndex)
                }
            }
        }
        
    }
    
}
