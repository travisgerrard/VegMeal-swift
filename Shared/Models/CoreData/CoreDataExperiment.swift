//
//  CoreDataExperiment.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/12/21.
//

import Foundation
import CoreData
import Apollo

class ManagedObject: NSManagedObject {
  @NSManaged var idString: String
}

protocol ManagedObjectSupport {}
extension ManagedObject: ManagedObjectSupport {}

extension ManagedObjectSupport where Self: ManagedObject {

  // Creates or retrieves an object with the specified id
  static func object(in context: NSManagedObjectContext, withId id: String) -> Self {
    let request = Self.fetchRequest() as! NSFetchRequest<Self>
    request.predicate = NSPredicate(format: "%K == %@",  #keyPath(idString), id)
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
    }
}

class MealIngredientListDemo: ManagedObject, Identifiable {
    @NSManaged var ingredientDemo: IngredientDemo?
    @NSManaged var amountDemo: AmountDemo?
    @NSManaged var mealDemo: NSSet?
}

extension MealIngredientListFragment : Identifiable {}

extension MealIngredientListDemo: FragmentUpdatable {
    typealias Fragment = MealIngredientListFragment
    
    func update(with fragment: Fragment) {
//        if let ingredientFragment = fragment.ingredient?.fragments.ingredientFragment {
//            self.ingredientDemo = ingredientFragment
//        }
    }
}

class IngredientDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var mealIngredientListDemo: NSSet?
}

extension IngredientFragment : Identifiable {}

extension IngredientDemo: FragmentUpdatable {
    typealias Fragment = IngredientFragment
    
    func update(with fragment: Fragment) {
        self.name = fragment.name
    }
}

class AmountDemo: ManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var mealIngredientListDemo: NSSet?
}

extension AmountFragment : Identifiable {}

extension AmountDemo: FragmentUpdatable {
    typealias Fragment = AmountFragment
    
    func update(with fragment: Fragment) {
        self.name = fragment.name
    }
}
