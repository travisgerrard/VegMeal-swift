//
//  ApolloNetworkingController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/2/20.
//

import Apollo
import Combine
import SwiftUI

class ApolloNetworkingController: ObservableObject {
    @Published var meals: [MealFragment] = []
    @Published var meal: MealFragment?
    @Published var mealsQueryRunning: Bool = false
    @Published var mealsQueryError: Error?
    
    
    init() {
        self.retrieveMeals()
    }
    
    func retrieveMeals () {
        self.mealsQueryError = nil
        self.mealsQueryRunning = true
        self.meals.removeAll()
        
        let query = AllMealsQueryQuery(skip: 0, first: 6)
        ApolloController.shared.apollo.fetch(query: query) { (results) in
            self.mealsQueryRunning = false
            switch results {
            case .failure(let error):
                self.mealsQueryError = error
                
            case .success(let graphQLResults):
                guard let searchResults = graphQLResults.data?.allMeals else { break }
                
                for item in searchResults {
                    if let fragment = item?.fragments.mealFragment {
                        self.meals.append(fragment)
                    }
                }
            }
        }
    }
    
    @Published var isUploadingImage: Bool = false
    @Published var uploadImageError: Error?
    
    func addNewMeal(authorId: String, inputImage: UIImage, name: String, description: String) {
        self.uploadImageError = nil
        self.isUploadingImage = true
        
        let file = GraphQLFile(
            fieldName: "mealImage",
            originalName: name,
            mimeType: "image/jpeg",
            data: inputImage.jpegData(compressionQuality: 0.5)!)
        
        
        let mutation = CreateMealMutation(authorId: authorId, name: name, description: description, mealImage: name)
        ApolloController.shared.apollo.upload(operation: mutation, files: [file]) { result in
            self.isUploadingImage = false
            
            switch result {
            case .failure(let error):
                self.uploadImageError = error
                
            case .success(let graphQLResult):
                print("Success: \(graphQLResult)")
                guard let fragment = graphQLResult.data?.createMeal?.fragments.mealFragment else { break }
                
                self.meals.append(fragment)
                
                if let errors = graphQLResult.errors {
                    print("Errors: \(errors)")
                    let errorOne = errors[0]
                    print(errorOne)
                    
                }
            }
            
        }
    }
    
    
    @Published var addingIngredientIsLoading: Bool = false
    @Published var addingIngredientError: Error?
    @Published var ingredient: String = ""
    @Published var amount: String = ""
    
    func createMealIngredientList(mealId: String) {
        
        
        self.addingIngredientError = nil
        self.addingIngredientIsLoading = true
        
        let mutation = AddMealIngredientListMutation(id: mealId, ingredient: ingredient, amount: amount);
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            self.addingIngredientIsLoading = false
            
            switch result {
            case .failure(let error):
                self.addingIngredientError = error
                
            case .success(let graphQLResult):
                print("Success: \(graphQLResult)")
                guard let mealIngredientListId = graphQLResult.data?.addMealIngredientList else { break }
                
                self.ingredient = ""
                self.amount = ""
                
                let query = GetMealIngredientListQuery(id: mealIngredientListId.id!)
                ApolloController.shared.apollo.fetch(query: query) { result in
                    switch result {
                    case .failure(let error):
                        self.addingIngredientError = error
                        
                    case .success(let graphQLResult):
                        guard let mealIngredientList = graphQLResult.data?.mealIngredientList else { break }
                        
                        if let mealToUpdateIndex = self.meals.firstIndex(where: {$0.id == mealId}) {
                            let ingredientListToAdd = MealFragment.IngredientList(id: mealIngredientList.id, ingredient: self.parseIngredient(object: mealIngredientList), amount: self.parseAmount(object: mealIngredientList))
                            print("ingredientListToAdd: \(ingredientListToAdd)")
                            
                            self.meals[mealToUpdateIndex].ingredientList.append(ingredientListToAdd)
                            print("self.meals[mealToUpdateIndex]: \(self.meals[mealToUpdateIndex].ingredientList)")
                            
                            self.meal!.ingredientList.append(ingredientListToAdd)
                        }
                        
                    }
                }
                
                
            }
        }
    }
    
    func parseAmount(object: GetMealIngredientListQuery.Data.MealIngredientList) -> MealFragment.IngredientList.Amount {
        guard let amountId = object.amount?.id else { return MealFragment.IngredientList.Amount(id: "", name: "") }
        guard let amountName = object.amount?.name else { return MealFragment.IngredientList.Amount(id: "", name: "") }
        
        return MealFragment.IngredientList.Amount(id: amountId, name: amountName)
    }
    
    func parseIngredient(object: GetMealIngredientListQuery.Data.MealIngredientList) -> MealFragment.IngredientList.Ingredient {
        guard let ingredientId = object.ingredient?.id else { return MealFragment.IngredientList.Ingredient(id: "", name: "") }
        guard let ingredientName = object.ingredient?.name else { return MealFragment.IngredientList.Ingredient(id: "", name: "") }
        
        return MealFragment.IngredientList.Ingredient(id: ingredientId, name: ingredientName)
    }
    
    func deleteMealIngredientList(mealIngredientListId: String, ingredientId: String, mealId: String) {
        let mutation = DeleteMealIngredientListMutation(mealIngredientListId: mealIngredientListId, ingredientId: ingredientId, mealId: mealId)
        
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {

            case .failure(let error):
                print(error)
            
            case .success(let graphQLResult):
                print("Success: \(graphQLResult)")
                
                if let mealToUpdateIndex = self.meals.firstIndex(where: {$0.id == mealId}){
                    if let ingredientListToDeleteIndex = self.meals[mealToUpdateIndex].ingredientList.firstIndex(where: {$0.id == mealIngredientListId}) {
                        self.meals[mealToUpdateIndex].ingredientList.remove(at: ingredientListToDeleteIndex)
                        self.meal!.ingredientList.remove(at: ingredientListToDeleteIndex)
                    }
                    
                   
                }
                
            }
            
        }
    }
    
    @Published var addingMealToGroceryListIsLoading: Bool = false
    @Published var addingMealToGroceryListWasSuccess: Bool = false
    
    // Add this function to the button press!
    func addMealToGroceryList(mealId: String, userId: String) {
        addingMealToGroceryListIsLoading = true
        
        let mutation = AddMealToGroceryListMutation(mealId: mealId, authorId: userId)
        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            self.addingMealToGroceryListIsLoading = false
            self.addingMealToGroceryListWasSuccess = true
            
            switch result {

            case .failure(let error):
                print(error)
            
            case .success(let graphQLResult):
                print("Success: \(graphQLResult)")
                
            }
            
        }
    }
}

