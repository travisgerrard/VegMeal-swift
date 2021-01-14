//
//  CoreDataCodable.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/8/21.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

class Amount: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, name, meal, mealIngredientList
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
             throw DecoderConfigurationError.missingManagedObjectContext
           }
        
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.meal = try container.decode(Set<Meal>.self, forKey: .meal) as NSSet
        self.mealIngredientList = try container.decode(Set<MealIngredientList>.self, forKey: .mealIngredientList) as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(meal as! Set<Meal>, forKey: .meal)
        try container.encode(meal as! Set<MealIngredientList>, forKey: .mealIngredientList)
    }
}

class Ingredient: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, name, category, ingredientImage, meal, mealIngredientList
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
             throw DecoderConfigurationError.missingManagedObjectContext
           }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(Int16.self, forKey: .category)
        self.ingredientImage = try container.decode(URL.self, forKey: .ingredientImage)
        self.meal = try container.decode(Set<Meal>.self, forKey: .meal) as NSSet
        self.mealIngredientList = try container.decode(Set<MealIngredientList>.self, forKey: .mealIngredientList) as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(ingredientImage, forKey: .ingredientImage)
        try container.encode(meal as! Set<Meal>, forKey: .meal)
        try container.encode(mealIngredientList as! Set<MealIngredientList>, forKey: .mealIngredientList)
    }
}

class Meal: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, createdAt, detail, mealImageUrl, name, amount, author, ingredient, ingredientList
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
             throw DecoderConfigurationError.missingManagedObjectContext
           }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.detail = try container.decode(String.self, forKey: .detail)
        self.mealImageUrl = try container.decode(URL.self, forKey: .mealImageUrl)
        self.name = try container.decode(String.self, forKey: .name)
        self.author = try container.decode(User.self, forKey: .author)
        self.amount = try container.decode(Set<Amount>.self, forKey: .amount) as NSSet
        self.ingredient = try container.decode(Set<Ingredient>.self, forKey: .ingredient) as NSSet
        self.ingredientList = try container.decode(Set<MealIngredientList>.self, forKey: .ingredientList) as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(detail, forKey: .detail)
        try container.encode(mealImageUrl, forKey: .mealImageUrl)
        try container.encode(name, forKey: .name)
        try container.encode(author, forKey: .author)
        try container.encode(amount as! Set<Amount>, forKey: .amount)
        try container.encode(ingredient as! Set<Ingredient>, forKey: .ingredient)
        try container.encode(ingredientList as! Set<MealIngredientList>, forKey: .ingredientList)

    }
}

class MealIngredientList: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, amount, ingredient, meal
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
             throw DecoderConfigurationError.missingManagedObjectContext
           }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.ingredient = try container.decode(Ingredient.self, forKey: .ingredient)
        self.amount = try container.decode(Amount.self, forKey: .amount)
        self.meal = try container.decode(Set<Meal>.self, forKey: .meal) as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encode(amount, forKey: .amount)
        try container.encode(meal as! Set<Meal>, forKey: .meal)

    }
}

class User: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, email, name, meals
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
             throw DecoderConfigurationError.missingManagedObjectContext
           }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.meals = try container.decode(Set<Meal>.self, forKey: .meals) as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(meals as! Set<Meal>, forKey: .meals)

    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
   
}
