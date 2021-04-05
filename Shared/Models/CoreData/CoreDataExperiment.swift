//
//  CoreDataExperiment.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/12/21.
//

import Foundation
import CoreData
import Apollo

// swiftlint:disable force_cast

class ManagedObject: NSManagedObject {
    @NSManaged var idString: String
}

protocol ManagedObjectSupport {}
extension ManagedObject: ManagedObjectSupport {}

extension ManagedObjectSupport where Self: ManagedObject {

    // Creates or retrieves an object with the specified id
    // swiftlint:disable:next identifier_name
    static func object(in context: NSManagedObjectContext, withId id: String) -> Self {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(idString), id)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false

        switch (try? context.fetch(request))?.first {
        case .some(let object):
            return object

        case .none:
            let newObject = Self(context: context)
            newObject.idString = id
            return newObject
        }
    }

    // Returns an existing object with the specified id
    // swiftlint:disable:next identifier_name
    static func existingObject(in context: NSManagedObjectContext, withId id: String) -> Self? {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(idString), id)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        return (try? context.fetch(request))?.first
    }

    // Configure and return a fetched results controller
    static func fetchedResultsController(in context: NSManagedObjectContext,
                                         sortDescriptors: [NSSortDescriptor]? = nil,
                                         predicate: NSPredicate? = nil,
                                         sectionKeyPath: String? = nil) -> NSFetchedResultsController<Self> {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context,
                                          sectionNameKeyPath: sectionKeyPath, cacheName: nil)
    }
}

protocol FragmentUpdatable {
    associatedtype Fragment: GraphQLFragment & Identifiable
    func update(with fragment: Fragment)
}

extension FragmentUpdatable where Self: ManagedObject {
    static func object(in context: NSManagedObjectContext, withFragment fragment: Self.Fragment?) -> Self? {
        // swiftlint:disable:next identifier_name
        guard let fragment = fragment, let id = fragment.id as? String else { return nil }
        let object = Self.object(in: context, withId: id)
        //    print(fragment)
        //    print(object)
        object.update(with: fragment)
        return object
    }
}

class MealDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var detail: String?
    @NSManaged var imageUrl: URL?
    @NSManaged var mealIngredientListDemo: NSSet?
    @NSManaged var groceryList: NSSet?
    @NSManaged var madeMeal: NSSet?
    @NSManaged var mealList: NSSet?
    @NSManaged var author: UserDemo?
    @NSManaged var createdAt: Date?
}

extension MealDemoFragment: Identifiable {}

extension MealDemo: FragmentUpdatable {
    typealias Fragment = MealDemoFragment
    
    func update(with fragment: Fragment) {
        self.name = fragment.name
        self.detail = fragment.description
        if let urlString = fragment.mealImage?.publicUrlTransformed {
            self.imageUrl =  URL(string: urlString)
        }
        
        if let author = fragment.author?.fragments.userDemoFragment {
            let authorDB = UserDemo.object(in: managedObjectContext!, withFragment: author)
            self.author = authorDB
        }
        
        if let createdAt = fragment.createdAt {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

            self.createdAt = dateFormatter.date(from: createdAt)
        }
        
        // Loads in meal ingredient list to meal...
        fragment.ingredientList.forEach {

            // Loads the mealIngredientList in the DB
            let mealIngredientListDemoFromFragment =
                MealIngredientListDemo.object(
                    in: managedObjectContext!,
                    withFragment: $0.fragments.mealIngredientListFragment
                )
            mealIngredientListDemoFromFragment?.mealDemo = self

            let mealIngredientListFragment = $0.fragments.mealIngredientListFragment

            if let ingredientFragment = mealIngredientListFragment.ingredient?.fragments.ingredientFragment {
                let ingredientDemo = IngredientDemo.object(in: managedObjectContext!, withFragment: ingredientFragment)
                mealIngredientListDemoFromFragment?.ingredientDemo = ingredientDemo
            }
            if let amountFragment = mealIngredientListFragment.amount?.fragments.amountFragment {
                let amountDemo = AmountDemo.object(in: managedObjectContext!, withFragment: amountFragment)
                mealIngredientListDemoFromFragment?.amountDemo = amountDemo
            }
        }
    }
}

class MealIngredientListDemo: ManagedObject, Identifiable {
    @NSManaged var ingredientDemo: IngredientDemo?
    @NSManaged var amountDemo: AmountDemo?
    @NSManaged var mealDemo: MealDemo?
}

extension MealIngredientListFragment: Identifiable {}

extension MealIngredientListDemo: FragmentUpdatable {
    typealias Fragment = MealIngredientListFragment

    func update(with fragment: Fragment) {

    }
}

class IngredientDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var category: Int16
    @NSManaged var mealIngredientListDemo: NSSet?
}

extension IngredientFragment: Identifiable {}

extension IngredientDemo: FragmentUpdatable {
    typealias Fragment = IngredientFragment

    func update(with fragment: Fragment) {
        self.name = fragment.name
        if let category = fragment.category {
            self.category = Int16(category)
        }
    }
}

class AmountDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var mealIngredientListDemo: NSSet?
}

extension AmountFragment: Identifiable {}

extension AmountDemo: FragmentUpdatable {
    typealias Fragment = AmountFragment

    func update(with fragment: Fragment) {
        self.name = fragment.name
    }
}

class MadeMeal: ManagedObject, Identifiable {
    @NSManaged var thoughts: String?
    @NSManaged var author: UserDemo?
    @NSManaged var dateMade: Date?
    @NSManaged var meal: MealDemo?
}

extension MadeMealFragment: Identifiable {}

extension MadeMeal: FragmentUpdatable {
    typealias Fragment = MadeMealFragment
    
    func update(with fragment: Fragment) {
        self.thoughts = fragment.thoughts
        if let author = fragment.author?.fragments.userDemoFragment {
            let authorDB = UserDemo.object(in: managedObjectContext!, withFragment: author)
            self.author = authorDB
        }
        if let dateMade = fragment.dateMade {
            var dateFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }
            
            self.dateMade = dateFormatter.date(from: dateMade)
        }
    }
    
}

class GroceryList: ManagedObject, Identifiable {
    @NSManaged var dateCompleted: Date?
    @NSManaged var isCompleted: Bool
    @NSManaged var author: UserDemo?
    @NSManaged var amount: AmountDemo?
    @NSManaged var ingredient: IngredientDemo?
    @NSManaged var meal: MealDemo?
    @NSManaged var category: Int16
}

extension GroceryListFragment: Identifiable {}

extension GroceryList: FragmentUpdatable {
    typealias Fragment = GroceryListFragment
    func update(with fragment: Fragment) {
        self.isCompleted = fragment.isCompleted!
        if let author = fragment.author?.fragments.userDemoFragment {
            let authorDB = UserDemo.object(in: managedObjectContext!, withFragment: author)
            self.author = authorDB
        }
        if let ingredient = fragment.ingredient?.fragments.ingredientFragment {
            let ingredientDB = IngredientDemo.object(in: managedObjectContext!, withFragment: ingredient)
            self.ingredient = ingredientDB
            if let category = ingredient.category {
                self.category = Int16(category)
            }
        }
        if let amount = fragment.amount?.fragments.amountFragment {
            let amountDB = AmountDemo.object(in: managedObjectContext!, withFragment: amount)
            self.amount = amountDB
        }
        if let meal = fragment.meal?.fragments.mealDemoFragment {
            let mealDB = MealDemo.object(in: managedObjectContext!, withFragment: meal)
            self.meal = mealDB
        }
        if let dateCompleted = fragment.dateCompleted {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

            self.dateCompleted = dateFormatter.date(from: dateCompleted)
        }
    }
}

class MealList: ManagedObject, Identifiable {
    @NSManaged var dateCompleted: Date?
    @NSManaged var isCompleted: Bool
    @NSManaged var author: UserDemo?
    @NSManaged var meal: MealDemo?
}

extension MealListFragment: Identifiable {}

extension MealList: FragmentUpdatable {
    typealias Fragment = MealListFragment

    func update(with fragment: Fragment) {
        self.isCompleted = fragment.isCompleted!
        if let author = fragment.author?.fragments.userDemoFragment {
            let authorDB = UserDemo.object(in: managedObjectContext!, withFragment: author)
            self.author = authorDB
        }

        if let dateCompleted = fragment.dateCompleted {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            self.dateCompleted = dateFormatter.date(from: dateCompleted)
        }
    }
}

class UserDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var followers: NSSet?
    @NSManaged var follows: NSSet?
    @NSManaged var groceryList: NSSet?
    @NSManaged var madeMeal: NSSet?
    @NSManaged var meal: NSSet?
    @NSManaged var mealList: NSSet?
}

extension UserDemoFragment: Identifiable {}

extension UserDemo: FragmentUpdatable {
    typealias Fragment = UserDemoFragment

    func update(with fragment: Fragment) {
        self.name = fragment.name
    }
}
