//
//  SocialApolloController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/1/21.
//

import SwiftUI
import Combine

class SocialApolloController: ObservableObject {
    @Published var recentlyAddedMeals = [MealFragment]()
    @Published var recentlyAddedComments = [MadeMealFragment]()
    @Published var getMealsForSocialQueryRunning: Bool = false
    @Published var getMealsForSocialQueryError: Error?
    
    func getMealsForSocial(authorId: String, followers: [OtherUser]) {
        self.getMealsForSocialQueryRunning = true

        var arrayOfFollwerId: [String] = []

        for follower in followers {
            arrayOfFollwerId.append(follower.id)
        }
        
        let query = AllMealsQuerySocialQuery(ids: [authorId] + arrayOfFollwerId)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            self.getMealsForSocialQueryRunning = false

            
            switch result {
            case .failure(let error):
                self.getMealsForSocialQueryError = error
                
            case .success(let graphQLResults):
                guard let mostRecentMeals = graphQLResults.data?.allMeals else { break }
                guard let mostRecentComments = graphQLResults.data?.allMadeMeals else { break }
                
                self.recentlyAddedMeals.removeAll()
                for meals in mostRecentMeals {
                    self.recentlyAddedMeals.append(meals!.fragments.mealFragment)
                }
                
                self.recentlyAddedComments.removeAll()
                for comments in mostRecentComments {
                    self.recentlyAddedComments.append(comments!.fragments.madeMealFragment)
                }
            }
        }
    }
}
