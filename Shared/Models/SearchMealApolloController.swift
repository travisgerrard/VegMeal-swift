//
//  SerachMealApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 12/20/20.
//

import SwiftUI
import Combine

class SearchMealApolloController: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchQueryIsLoading: Bool = false
    @Published var searchMealList = [MealFragment]()

    private var cancellable: AnyCancellable? = nil
    init() {
        cancellable = AnyCancellable(
          $searchText.removeDuplicates()
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .sink { searchText in
              self.searchForMeal()
          })
      }
    
    func searchForMeal() {
        if searchText.count > 0 {
            self.searchQueryIsLoading = true

            let query = SearchForMealsQuery(searchText: searchText)
            
            ApolloController.shared.apollo.fetch(query: query) { result in

                self.searchQueryIsLoading = false

                switch result {
                case .success(let graphQLResult):
                    
                    if let data = graphQLResult.data {
                        if let allMeals = data.allMeals {

                            self.searchMealList.removeAll()
                            for meal in allMeals {
                                self.searchMealList.append(meal!.fragments.mealFragment)
                            }
                        }
                    }

                case .failure(let error):
                    print(error)
                }
            }
            
        } else {
            searchMealList.removeAll()
        }
    }
}
