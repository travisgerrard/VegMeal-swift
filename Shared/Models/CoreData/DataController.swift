//
//  DataController.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/6/21.
//

import CoreData
import SwiftUI
import WidgetKit
import Apollo

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let storeURL = AppGroup.veggily.containerURL.appendingPathComponent("Veggily.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)

        container = NSPersistentContainer(name: "VeggilyDataModel")
        container.persistentStoreDescriptions = [description]

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error createg preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    func createSampleData() throws {
        let viewContext = container.viewContext

        let mealFragmentDemo = MealDemoFragment(
            id: "1",
            name: "Demo Meal",
            description: "Meal Detail",
            createdAt: "6:24 PM 10th February 2021 +00:00",
            mealImage: nil,
            ingredientList: [],
            author: nil
        )

        _ = MealDemo.object(in: viewContext, withFragment: mealFragmentDemo)

    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
    }

    func loadAllDataAndSync() {
        // If not logged in, used dummy blank userid
        let userid = UserDefaults.shared.string(forKey: "userid") ?? ""

        let userIdForQuery = userid != "" ? userid : "000000000000"

        let query = UpdateAllOnLaunchQuery(userId: userIdForQuery)
        ApolloController.shared.apollo.fetch(query: query) { result in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let graphQLResult):
                print("!!!! - Loaded update all query with userID \(userIdForQuery)")
                if let data = graphQLResult.data {
                    self.syncOnLoad(data)
                }
            }
        }
    }

    func syncOnLoad(_ data: UpdateAllOnLaunchQuery.Data) {
        container.performBackgroundTask { backgroundContext in

            // Load meals
            if let allMeals = data.allMeals {
                self.syncMeals(backgroundContext, meals: allMeals)
            }

            // Load ingredients/amounts
            if let allAmounts = data.allAmounts {
                self.syncAmounts(backgroundContext, amounts: allAmounts)
            }

            if let allIngredients = data.allIngredients {
                self.syncIngredients(backgroundContext, ingredients: allIngredients)
            }

            // Load grocery list
            if let allGroceryLists = data.allGroceryLists {
                self.syncGroceryList(backgroundContext, groceries: allGroceryLists)
            }

            // Load meal list
            if let allMealLists = data.allMealLists {
                self.syncMealList(backgroundContext, mealLists: allMealLists)
                WidgetCenter.shared.reloadAllTimelines()
            }

            // Load user
            if let allUsers = data.allUsers {
                self.syncUsers(backgroundContext, userList: allUsers)
            }
        }
    }

    func syncMeals(
        _ context: NSManagedObjectContext,
        meals allMeals: [UpdateAllOnLaunchQuery.Data.AllMeal?]
    ) {
        let localMealItemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MealDemo")
        var localMealItems = try? context.fetch(localMealItemsFetch) as? [MealDemo]

        for meal in allMeals {
            if let mealDemoFragment = meal?.fragments.mealDemoFragment {

                // If its exists on device and on server - remove from local items array
                if let indexOfValueFoundItem = localMealItems?.firstIndex(
                    where: { $0.idString == mealDemoFragment.id }
                ) {
                    localMealItems?.remove(at: indexOfValueFoundItem)
                } else {
                    // If it exists on server but not on device, add it to device
                    _ = MealDemo.object(in: context, withFragment: mealDemoFragment)
                }

            }
        }

        localMealItems?.forEach {
            context.delete($0)
        }

        try? context.save()
    }

    func syncAmounts(
        _ context: NSManagedObjectContext,
        amounts allAmounts: [UpdateAllOnLaunchQuery.Data.AllAmount?]
    ) {
        let localAmountsItemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AmountDemo")
        var localAmountsItems = try? context.fetch(localAmountsItemsFetch) as? [AmountDemo]

        for amount in allAmounts {
            if let amountFragment = amount?.fragments.amountFragment {

                // If its exists on device and on server - remove from local items array
                if let indexOfValueFoundItem = localAmountsItems?.firstIndex(
                    where: {$0.idString == amountFragment.id}
                ) {
                    localAmountsItems?.remove(at: indexOfValueFoundItem)
                } else {
                    // If it exists on server but not on device, add it to device
                    _ = AmountDemo.object(in: context, withFragment: amountFragment)
                }

            }
        }

        // If it exists on device, but no on server should be itesm left over in local times array
        // ?Batch? delete all items that remain on array
        localAmountsItems?.forEach {
            context.delete($0)
        }

        try? context.save()
    }

    func syncIngredients(
        _ context: NSManagedObjectContext,
        ingredients allIngredients: [UpdateAllOnLaunchQuery.Data.AllIngredient?]
    ) {
        // Get all local items
        let localIngredientsItemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientDemo")
        var localIngredientsItems = try? context.fetch(localIngredientsItemsFetch) as? [IngredientDemo]

        for ingredient in allIngredients {
            if let ingredientFragment = ingredient?.fragments.ingredientFragment {

                // If its exists on device and on server - remove from local items array
                if let indexOfValueFoundItem = localIngredientsItems?.firstIndex(
                    where: { $0.idString == ingredientFragment.id }
                ) {
                    localIngredientsItems?.remove(at: indexOfValueFoundItem)
                } else {
                    // If it exists on server but not on device, add it to device
                    _ = IngredientDemo.object(in: context, withFragment: ingredientFragment)
                }
            }
        }

        localIngredientsItems?.forEach {
            context.delete($0)
        }
        try? context.save()
    }

    func syncGroceryList(
        _ context: NSManagedObjectContext,
        groceries allGroceries: [UpdateAllOnLaunchQuery.Data.AllGroceryList?]
    ) {
        // Get all local items
        let localGroceryItemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GroceryList")
        var localGroceryItems = try? context.fetch(localGroceryItemsFetch) as? [GroceryList]

        for groceryItem in allGroceries {

            // For each item, see if it exists on device

            if let groceryListFragment = groceryItem?.fragments.groceryListFragment {

                // ISSUE HERE IS THAT FOR ITEMS THAT ARE COMPLETED
                // BUT NOT REMOVED FROM LIST, THEY DO NOT SYNC COMPLETED STATUS

                // If its exists on device and on server - remove from local item array
                if let indexOfValueFoundItem = localGroceryItems?.firstIndex(
                    where: {$0.idString == groceryListFragment.id && groceryListFragment.isCompleted == $0.isCompleted}
                ) {
                    localGroceryItems?.remove(at: indexOfValueFoundItem)
                } else {
                    // If it exists on server but not on device, add it to device
                    _ = GroceryList.object(in: context, withFragment: groceryListFragment)
                }
            }
        }

        localGroceryItems?.forEach {
            context.delete($0)
        }

        try? context.save()
    }

    func syncMealList(
        _ context: NSManagedObjectContext,
        mealLists allMealLists: [UpdateAllOnLaunchQuery.Data.AllMealList?]
    ) {
        // Get all local items
        let localMealListItemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MealList")
        var localMealListItems = try? context.fetch(localMealListItemsFetch) as? [MealList]

        for mealListItem in allMealLists {
            if let mealListFragment = mealListItem?.fragments.mealListFragment {

                // If its exists on device and on server - remove from local items array
                if let indexOfValueFoundItem = localMealListItems?.firstIndex(
                    where: { $0.idString == mealListFragment.id }
                ) {
                    localMealListItems?.remove(at: indexOfValueFoundItem)
                } else {
                    // If it exists on server but not on device, add it to device
                    let mealListItemDB = MealList.object(in: context, withFragment: mealListFragment)

                    let mealListMeal = MealDemo.object(
                        in: context,
                        withFragment: mealListFragment.meal?.fragments.mealDemoFragment
                    )

                    mealListItemDB?.meal = mealListMeal

                }

            }
        }

        // If it exists on device, but no on server should be in left over in local times array
        // ?Batch? delete all items that remain on array
        localMealListItems?.forEach {
            context.delete($0)
        }

        try? context.save()
    }

    func syncUsers(
        _ context: NSManagedObjectContext,
        userList allUsers: [UpdateAllOnLaunchQuery.Data.AllUser?]
    ) {
        if allUsers.count > 0 {
            if let currentUser = allUsers[0]?.fragments.userDemoFragment {
                let currentUserDB = UserDemo.object(in: context, withFragment: currentUser)

                allUsers[0]?.follows.forEach {
                    let followsUserDB = UserDemo.object(in: context, withFragment: $0.fragments.userDemoFragment)

                    currentUserDB?.mutableSetValue(forKey: "follows").add(followsUserDB!)

                }
                try? context.save()
            }

        }
    }

    func addIngredientToGroceryList(
        amountToLookFor amountString: String,
        ingredientToLookFor ingredientString: String,
        addToMeal meal: MealDemo?
        ) {

        // Find out if amounts / ingredient at already in the database
        let amountNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AmountDemo")
        let ingredientNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientDemo")

        amountNameFetch.predicate = NSPredicate(format: "name == %@", amountString)
        ingredientNameFetch.predicate = NSPredicate(format: "name == %@", ingredientString)

        var amountDB: AmountDemo?
        var ingredientDB: IngredientDemo?

        do {
            let fetchedAmountByName = try self.container.viewContext.fetch(amountNameFetch) as? [AmountDemo] ?? []
            let fetchedIngredientByName = try self.container.viewContext.fetch(ingredientNameFetch) as? [IngredientDemo] ?? []

            if fetchedAmountByName.count > 0 {
                amountDB = fetchedAmountByName[0]
            }

            if fetchedIngredientByName.count > 0 {
                ingredientDB = fetchedIngredientByName[0]
            }
        } catch {
            fatalError("Failed with error: \(error)")
        }

        if amountDB == nil && ingredientDB == nil {
            // if amount & ingredient does not exist, add them to the database
            let mutation = CreateIngredientAndAmountMutation(ingredientName: ingredientString, amountName: amountString)

            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    print("Success: \(graphQLResult)")
                    if let data = graphQLResult.data {
                        if let createAmount = data.createAmount {
                            let amountFragment = createAmount.fragments.amountFragment
                            amountDB = AmountDemo.object(in: self.container.viewContext, withFragment: amountFragment)
                            if let createIngredient = data.createIngredient {
                                let ingredientFragment = createIngredient.fragments.ingredientFragment
                                ingredientDB = IngredientDemo.object(
                                    in: self.container.viewContext,
                                    withFragment: ingredientFragment
                                )
                                self.addIngredientAndAmountToGroceryList(
                                    addToMeal: meal,
                                    withIngredient: ingredientDB,
                                    withAmount: amountDB
                                )

                            }
                        }

                    }
                }
            }
        } else if amountDB == nil && ingredientDB != nil {
            // add amount to database
            let mutation = CreateAmountMutation(name: amountString)

            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createAmount = data.createAmount {
                            let amountFragment = createAmount.fragments.amountFragment
                            amountDB = AmountDemo.object(in: self.container.viewContext, withFragment: amountFragment)
                            self.addIngredientAndAmountToGroceryList(
                                addToMeal: meal,
                                withIngredient: ingredientDB,
                                withAmount: amountDB
                            )
                        }
                    }
                }
            }
        } else if amountDB != nil && ingredientDB == nil {
            // add ingredient to the database
            let mutation = CreateIngredientMutation(name: ingredientString)

            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createIngredient = data.createIngredient {
                            let ingredientFragment = createIngredient.fragments.ingredientFragment
                            ingredientDB = IngredientDemo.object(
                                in: self.container.viewContext,
                                withFragment: ingredientFragment
                            )
                            self.addIngredientAndAmountToGroceryList(
                                addToMeal: meal,
                                withIngredient: ingredientDB,
                                withAmount: amountDB
                            )
                        }
                    }
                }
            }
        } else if amountDB != nil && ingredientDB != nil {
            self.addIngredientAndAmountToGroceryList(
                addToMeal: meal,
                withIngredient: ingredientDB,
                withAmount: amountDB
            )
        }
    }

    func addIngredientAndAmountToGroceryList(
        addToMeal meal: MealDemo?,
        withIngredient ingredientDB: IngredientDemo?,
        withAmount amountDB: AmountDemo?
    ) {

        // now we need to add the grocery item to the database
        if meal != nil {
            let mutation = CreateMealIngredientListMutation(
                mealId: meal!.idString,
                ingredientId: ingredientDB!.idString,
                amountId: amountDB!.idString
            )

            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createMealIngredientList = data.createMealIngredientList {
                            let mealIngredientListFragment = createMealIngredientList.fragments.mealIngredientListFragment

                            let mealIngredientListDB = MealIngredientListDemo.object(in: self.container.viewContext, withFragment: mealIngredientListFragment)

                            mealIngredientListDB?.amountDemo = amountDB
                            mealIngredientListDB?.ingredientDemo = ingredientDB

                            meal?.mutableSetValue(forKey: "mealIngredientListDemo").add(mealIngredientListDB!)

                            try? self.container.viewContext.save()

                            // Reset vars after adding

//                            amountDB = nil
//                            ingredientDB = nil
//                            amountString = ""
//                            ingredientString = ""
                        }

                    }
                }
            }
        } else {
            let mutation = CreateGrocerylistItemMutation(
                ingredientId: ingredientDB!.idString,
                amountId: amountDB!.idString,
                userId: UserDefaults.shared.string(forKey: "userid")!
            )

            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .failure(let error):
                    print(error)

                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        if let createGroceryList = data.createGroceryList {
                            let groceryListFragment = createGroceryList.fragments.groceryListFragment

                            let groceryListDB = GroceryList.object(
                                in: self.container.viewContext,
                                withFragment: groceryListFragment
                            )
                            groceryListDB?.amount = amountDB
                            groceryListDB?.ingredient = ingredientDB

                            try? self.container.viewContext.save()

                            // Reset vars after adding
//                            amountDB = nil
//                            ingredientDB = nil
//                            amountString = ""
//                            ingredientString = ""
                        }
                    }
                }
            }
        }
    }
}
