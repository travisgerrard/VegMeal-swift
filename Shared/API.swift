// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum UserPermissionType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case admin
  case editor
  case user
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ADMIN": self = .admin
      case "EDITOR": self = .editor
      case "USER": self = .user
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .admin: return "ADMIN"
      case .editor: return "EDITOR"
      case .user: return "USER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserPermissionType, rhs: UserPermissionType) -> Bool {
    switch (lhs, rhs) {
      case (.admin, .admin): return true
      case (.editor, .editor): return true
      case (.user, .user): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserPermissionType] {
    return [
      .admin,
      .editor,
      .user,
    ]
  }
}

public final class AllMealIngredientListsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ALL_MEAL_INGREDIENT_LISTS {
      allMealIngredientLists {
        __typename
        ...MealIngredientListFragment
      }
    }
    """

  public let operationName: String = "ALL_MEAL_INGREDIENT_LISTS"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMealIngredientLists", type: .list(.object(AllMealIngredientList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMealIngredientLists: [AllMealIngredientList?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMealIngredientLists": allMealIngredientLists.flatMap { (value: [AllMealIngredientList?]) -> [ResultMap?] in value.map { (value: AllMealIngredientList?) -> ResultMap? in value.flatMap { (value: AllMealIngredientList) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all MealIngredientList items which match the where clause.
    public var allMealIngredientLists: [AllMealIngredientList?]? {
      get {
        return (resultMap["allMealIngredientLists"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMealIngredientList?] in value.map { (value: ResultMap?) -> AllMealIngredientList? in value.flatMap { (value: ResultMap) -> AllMealIngredientList in AllMealIngredientList(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMealIngredientList?]) -> [ResultMap?] in value.map { (value: AllMealIngredientList?) -> ResultMap? in value.flatMap { (value: AllMealIngredientList) -> ResultMap in value.resultMap } } }, forKey: "allMealIngredientLists")
      }
    }

    public struct AllMealIngredientList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealIngredientList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealIngredientListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealIngredientListFragment: MealIngredientListFragment {
          get {
            return MealIngredientListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MealDemoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MealDemo($id: ID!) {
      Meal(where: {id: $id}) {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public let operationName: String = "MealDemo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Meal", arguments: ["where": ["id": GraphQLVariable("id")]], type: .object(Meal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(meal: Meal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
    }

    /// Search for the Meal item with the matching ID.
    public var meal: Meal? {
      get {
        return (resultMap["Meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Meal")
      }
    }

    public struct Meal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealDemoFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealDemoFragment: MealDemoFragment {
          get {
            return MealDemoFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AllMealsDemoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AllMealsDemo {
      allMeals {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public let operationName: String = "AllMealsDemo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMeals", type: .list(.object(AllMeal.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMeals: [AllMeal?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMeals": allMeals.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Meal items which match the where clause.
    public var allMeals: [AllMeal?]? {
      get {
        return (resultMap["allMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMeal?] in value.map { (value: ResultMap?) -> AllMeal? in value.flatMap { (value: ResultMap) -> AllMeal in AllMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }, forKey: "allMeals")
      }
    }

    public struct AllMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealDemoFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealDemoFragment: MealDemoFragment {
          get {
            return MealDemoFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_MEAL($authorId: ID!, $name: String, $description: String, $mealImage: Upload) {
      createMeal(
        data: {name: $name, description: $description, mealImage: $mealImage, author: {connect: {id: $authorId}}}
      ) {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public let operationName: String = "CREATE_MEAL"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var authorId: GraphQLID
  public var name: String?
  public var description: String?
  public var mealImage: String?

  public init(authorId: GraphQLID, name: String? = nil, description: String? = nil, mealImage: String? = nil) {
    self.authorId = authorId
    self.name = name
    self.description = description
    self.mealImage = mealImage
  }

  public var variables: GraphQLMap? {
    return ["authorId": authorId, "name": name, "description": description, "mealImage": mealImage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createMeal", arguments: ["data": ["name": GraphQLVariable("name"), "description": GraphQLVariable("description"), "mealImage": GraphQLVariable("mealImage"), "author": ["connect": ["id": GraphQLVariable("authorId")]]]], type: .object(CreateMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMeal: CreateMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMeal": createMeal.flatMap { (value: CreateMeal) -> ResultMap in value.resultMap }])
    }

    /// Create a single Meal item.
    public var createMeal: CreateMeal? {
      get {
        return (resultMap["createMeal"] as? ResultMap).flatMap { CreateMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createMeal")
      }
    }

    public struct CreateMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealDemoFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealDemoFragment: MealDemoFragment {
          get {
            return MealDemoFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateMealWithoutImageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_MEAL_WITHOUT_IMAGE($authorId: ID!, $name: String, $description: String) {
      createMeal(
        data: {name: $name, description: $description, author: {connect: {id: $authorId}}}
      ) {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public let operationName: String = "CREATE_MEAL_WITHOUT_IMAGE"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var authorId: GraphQLID
  public var name: String?
  public var description: String?

  public init(authorId: GraphQLID, name: String? = nil, description: String? = nil) {
    self.authorId = authorId
    self.name = name
    self.description = description
  }

  public var variables: GraphQLMap? {
    return ["authorId": authorId, "name": name, "description": description]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createMeal", arguments: ["data": ["name": GraphQLVariable("name"), "description": GraphQLVariable("description"), "author": ["connect": ["id": GraphQLVariable("authorId")]]]], type: .object(CreateMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMeal: CreateMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMeal": createMeal.flatMap { (value: CreateMeal) -> ResultMap in value.resultMap }])
    }

    /// Create a single Meal item.
    public var createMeal: CreateMeal? {
      get {
        return (resultMap["createMeal"] as? ResultMap).flatMap { CreateMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createMeal")
      }
    }

    public struct CreateMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealDemoFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealDemoFragment: MealDemoFragment {
          get {
            return MealDemoFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UPDATE_MEAL($name: String, $description: String, $id: ID!) {
      updateMeal(id: $id, data: {name: $name, description: $description}) {
        __typename
        ...MealFragment
      }
    }
    """

  public let operationName: String = "UPDATE_MEAL"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var name: String?
  public var description: String?
  public var id: GraphQLID

  public init(name: String? = nil, description: String? = nil, id: GraphQLID) {
    self.name = name
    self.description = description
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["name": name, "description": description, "id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateMeal", arguments: ["id": GraphQLVariable("id"), "data": ["name": GraphQLVariable("name"), "description": GraphQLVariable("description")]], type: .object(UpdateMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateMeal: UpdateMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateMeal": updateMeal.flatMap { (value: UpdateMeal) -> ResultMap in value.resultMap }])
    }

    /// Update a single Meal item by ID.
    public var updateMeal: UpdateMeal? {
      get {
        return (resultMap["updateMeal"] as? ResultMap).flatMap { UpdateMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateMeal")
      }
    }

    public struct UpdateMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealFragment: MealFragment {
          get {
            return MealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateMealWithImageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UPDATE_MEAL_WITH_IMAGE($name: String, $description: String, $id: ID!, $mealImage: Upload) {
      updateMeal(
        id: $id
        data: {name: $name, description: $description, mealImage: $mealImage}
      ) {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public let operationName: String = "UPDATE_MEAL_WITH_IMAGE"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var name: String?
  public var description: String?
  public var id: GraphQLID
  public var mealImage: String?

  public init(name: String? = nil, description: String? = nil, id: GraphQLID, mealImage: String? = nil) {
    self.name = name
    self.description = description
    self.id = id
    self.mealImage = mealImage
  }

  public var variables: GraphQLMap? {
    return ["name": name, "description": description, "id": id, "mealImage": mealImage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateMeal", arguments: ["id": GraphQLVariable("id"), "data": ["name": GraphQLVariable("name"), "description": GraphQLVariable("description"), "mealImage": GraphQLVariable("mealImage")]], type: .object(UpdateMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateMeal: UpdateMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateMeal": updateMeal.flatMap { (value: UpdateMeal) -> ResultMap in value.resultMap }])
    }

    /// Update a single Meal item by ID.
    public var updateMeal: UpdateMeal? {
      get {
        return (resultMap["updateMeal"] as? ResultMap).flatMap { UpdateMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateMeal")
      }
    }

    public struct UpdateMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealDemoFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealDemoFragment: MealDemoFragment {
          get {
            return MealDemoFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AddGroceryListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ADD_GROCERY_LIST($ingredient: String!, $amount: String!) {
      addGroceryList(ingredient: $ingredient, amount: $amount) {
        __typename
        ...GroceryListFragment
      }
    }
    """

  public let operationName: String = "ADD_GROCERY_LIST"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    return document
  }

  public var ingredient: String
  public var amount: String

  public init(ingredient: String, amount: String) {
    self.ingredient = ingredient
    self.amount = amount
  }

  public var variables: GraphQLMap? {
    return ["ingredient": ingredient, "amount": amount]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addGroceryList", arguments: ["ingredient": GraphQLVariable("ingredient"), "amount": GraphQLVariable("amount")], type: .object(AddGroceryList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addGroceryList: AddGroceryList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addGroceryList": addGroceryList.flatMap { (value: AddGroceryList) -> ResultMap in value.resultMap }])
    }

    public var addGroceryList: AddGroceryList? {
      get {
        return (resultMap["addGroceryList"] as? ResultMap).flatMap { AddGroceryList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addGroceryList")
      }
    }

    public struct AddGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AddMealIngredientListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ADD_MEAL_INGREDIENT_LIST($id: ID!, $ingredient: String!, $amount: String!) {
      addMealIngredientList(id: $id, ingredient: $ingredient, amount: $amount) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "ADD_MEAL_INGREDIENT_LIST"

  public var id: GraphQLID
  public var ingredient: String
  public var amount: String

  public init(id: GraphQLID, ingredient: String, amount: String) {
    self.id = id
    self.ingredient = ingredient
    self.amount = amount
  }

  public var variables: GraphQLMap? {
    return ["id": id, "ingredient": ingredient, "amount": amount]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addMealIngredientList", arguments: ["id": GraphQLVariable("id"), "ingredient": GraphQLVariable("ingredient"), "amount": GraphQLVariable("amount")], type: .object(AddMealIngredientList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addMealIngredientList: AddMealIngredientList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addMealIngredientList": addMealIngredientList.flatMap { (value: AddMealIngredientList) -> ResultMap in value.resultMap }])
    }

    public var addMealIngredientList: AddMealIngredientList? {
      get {
        return (resultMap["addMealIngredientList"] as? ResultMap).flatMap { AddMealIngredientList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addMealIngredientList")
      }
    }

    public struct AddMealIngredientList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealIngredientList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class GetMealIngredientListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_MEAL_INGREDIENT_LIST($id: ID!) {
      MealIngredientList(where: {id: $id}) {
        __typename
        id
        ingredient {
          __typename
          id
          name
        }
        amount {
          __typename
          id
          name
        }
      }
    }
    """

  public let operationName: String = "GET_MEAL_INGREDIENT_LIST"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("MealIngredientList", arguments: ["where": ["id": GraphQLVariable("id")]], type: .object(MealIngredientList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(mealIngredientList: MealIngredientList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "MealIngredientList": mealIngredientList.flatMap { (value: MealIngredientList) -> ResultMap in value.resultMap }])
    }

    /// Search for the MealIngredientList item with the matching ID.
    public var mealIngredientList: MealIngredientList? {
      get {
        return (resultMap["MealIngredientList"] as? ResultMap).flatMap { MealIngredientList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "MealIngredientList")
      }
    }

    public struct MealIngredientList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealIngredientList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("ingredient", type: .object(Ingredient.selections)),
          GraphQLField("amount", type: .object(Amount.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, ingredient: Ingredient? = nil, amount: Amount? = nil) {
        self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id, "ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }, "amount": amount.flatMap { (value: Amount) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var ingredient: Ingredient? {
        get {
          return (resultMap["ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "ingredient")
        }
      }

      public var amount: Amount? {
        get {
          return (resultMap["amount"] as? ResultMap).flatMap { Amount(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "amount")
        }
      }

      public struct Ingredient: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Ingredient"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Amount: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Amount"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class SearchForIngredientQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SEARCH_FOR_INGREDIENT($inputValue: String) {
      allIngredients(where: {name_starts_with: $inputValue}) {
        __typename
        id
        name
      }
    }
    """

  public let operationName: String = "SEARCH_FOR_INGREDIENT"

  public var inputValue: String?

  public init(inputValue: String? = nil) {
    self.inputValue = inputValue
  }

  public var variables: GraphQLMap? {
    return ["inputValue": inputValue]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allIngredients", arguments: ["where": ["name_starts_with": GraphQLVariable("inputValue")]], type: .list(.object(AllIngredient.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allIngredients: [AllIngredient?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allIngredients": allIngredients.flatMap { (value: [AllIngredient?]) -> [ResultMap?] in value.map { (value: AllIngredient?) -> ResultMap? in value.flatMap { (value: AllIngredient) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Ingredient items which match the where clause.
    public var allIngredients: [AllIngredient?]? {
      get {
        return (resultMap["allIngredients"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllIngredient?] in value.map { (value: ResultMap?) -> AllIngredient? in value.flatMap { (value: ResultMap) -> AllIngredient in AllIngredient(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllIngredient?]) -> [ResultMap?] in value.map { (value: AllIngredient?) -> ResultMap? in value.flatMap { (value: AllIngredient) -> ResultMap in value.resultMap } } }, forKey: "allIngredients")
      }
    }

    public struct AllIngredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class SearchForAmountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SEARCH_FOR_AMOUNT($inputValue: String) {
      allAmounts(where: {name_starts_with: $inputValue}) {
        __typename
        id
        name
      }
    }
    """

  public let operationName: String = "SEARCH_FOR_AMOUNT"

  public var inputValue: String?

  public init(inputValue: String? = nil) {
    self.inputValue = inputValue
  }

  public var variables: GraphQLMap? {
    return ["inputValue": inputValue]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allAmounts", arguments: ["where": ["name_starts_with": GraphQLVariable("inputValue")]], type: .list(.object(AllAmount.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allAmounts: [AllAmount?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allAmounts": allAmounts.flatMap { (value: [AllAmount?]) -> [ResultMap?] in value.map { (value: AllAmount?) -> ResultMap? in value.flatMap { (value: AllAmount) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Amount items which match the where clause.
    public var allAmounts: [AllAmount?]? {
      get {
        return (resultMap["allAmounts"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllAmount?] in value.map { (value: ResultMap?) -> AllAmount? in value.flatMap { (value: ResultMap) -> AllAmount in AllAmount(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllAmount?]) -> [ResultMap?] in value.map { (value: AllAmount?) -> ResultMap? in value.flatMap { (value: AllAmount) -> ResultMap in value.resultMap } } }, forKey: "allAmounts")
      }
    }

    public struct AllAmount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Amount"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class DeleteMealMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DELETE_MEAL_MUTATION($id: ID!) {
      deleteMeal(id: $id) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "DELETE_MEAL_MUTATION"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteMeal", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteMeal: DeleteMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteMeal": deleteMeal.flatMap { (value: DeleteMeal) -> ResultMap in value.resultMap }])
    }

    /// Delete a single Meal item by ID.
    public var deleteMeal: DeleteMeal? {
      get {
        return (resultMap["deleteMeal"] as? ResultMap).flatMap { DeleteMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteMeal")
      }
    }

    public struct DeleteMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "Meal", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class GetGroceryListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_GROCERY_LIST($id: ID!) {
      groceryToComplete: allGroceryLists(
        where: {author: {id: $id}, isCompleted: false}
      ) {
        __typename
        ...GroceryListFragment
      }
      groceryCompleted: allGroceryLists(
        where: {author: {id: $id}, isCompleted: true}
        sortBy: dateCompleted_DESC
      ) {
        __typename
        ...GroceryListFragment
      }
    }
    """

  public let operationName: String = "GET_GROCERY_LIST"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allGroceryLists", alias: "groceryToComplete", arguments: ["where": ["author": ["id": GraphQLVariable("id")], "isCompleted": false]], type: .list(.object(GroceryToComplete.selections))),
        GraphQLField("allGroceryLists", alias: "groceryCompleted", arguments: ["where": ["author": ["id": GraphQLVariable("id")], "isCompleted": true], "sortBy": "dateCompleted_DESC"], type: .list(.object(GroceryCompleted.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(groceryToComplete: [GroceryToComplete?]? = nil, groceryCompleted: [GroceryCompleted?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "groceryToComplete": groceryToComplete.flatMap { (value: [GroceryToComplete?]) -> [ResultMap?] in value.map { (value: GroceryToComplete?) -> ResultMap? in value.flatMap { (value: GroceryToComplete) -> ResultMap in value.resultMap } } }, "groceryCompleted": groceryCompleted.flatMap { (value: [GroceryCompleted?]) -> [ResultMap?] in value.map { (value: GroceryCompleted?) -> ResultMap? in value.flatMap { (value: GroceryCompleted) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all GroceryList items which match the where clause.
    public var groceryToComplete: [GroceryToComplete?]? {
      get {
        return (resultMap["groceryToComplete"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GroceryToComplete?] in value.map { (value: ResultMap?) -> GroceryToComplete? in value.flatMap { (value: ResultMap) -> GroceryToComplete in GroceryToComplete(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GroceryToComplete?]) -> [ResultMap?] in value.map { (value: GroceryToComplete?) -> ResultMap? in value.flatMap { (value: GroceryToComplete) -> ResultMap in value.resultMap } } }, forKey: "groceryToComplete")
      }
    }

    /// Search for all GroceryList items which match the where clause.
    public var groceryCompleted: [GroceryCompleted?]? {
      get {
        return (resultMap["groceryCompleted"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GroceryCompleted?] in value.map { (value: ResultMap?) -> GroceryCompleted? in value.flatMap { (value: ResultMap) -> GroceryCompleted in GroceryCompleted(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GroceryCompleted?]) -> [ResultMap?] in value.map { (value: GroceryCompleted?) -> ResultMap? in value.flatMap { (value: GroceryCompleted) -> ResultMap in value.resultMap } } }, forKey: "groceryCompleted")
      }
    }

    public struct GroceryToComplete: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct GroceryCompleted: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetAllGroceryListItemsForUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_ALL_GROCERY_LIST_ITEMS_FOR_USER($id: ID!) {
      allGroceryLists(where: {author: {id: $id}}) {
        __typename
        ...GroceryListFragment
      }
    }
    """

  public let operationName: String = "GET_ALL_GROCERY_LIST_ITEMS_FOR_USER"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allGroceryLists", arguments: ["where": ["author": ["id": GraphQLVariable("id")]]], type: .list(.object(AllGroceryList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allGroceryLists: [AllGroceryList?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allGroceryLists": allGroceryLists.flatMap { (value: [AllGroceryList?]) -> [ResultMap?] in value.map { (value: AllGroceryList?) -> ResultMap? in value.flatMap { (value: AllGroceryList) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all GroceryList items which match the where clause.
    public var allGroceryLists: [AllGroceryList?]? {
      get {
        return (resultMap["allGroceryLists"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllGroceryList?] in value.map { (value: ResultMap?) -> AllGroceryList? in value.flatMap { (value: ResultMap) -> AllGroceryList in AllGroceryList(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllGroceryList?]) -> [ResultMap?] in value.map { (value: AllGroceryList?) -> ResultMap? in value.flatMap { (value: AllGroceryList) -> ResultMap in value.resultMap } } }, forKey: "allGroceryLists")
      }
    }

    public struct AllGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetGroceryListItemQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_GROCERY_LIST_ITEM($id: ID!) {
      allGroceryLists(where: {id: $id}) {
        __typename
        ...GroceryListFragment
      }
    }
    """

  public let operationName: String = "GET_GROCERY_LIST_ITEM"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allGroceryLists", arguments: ["where": ["id": GraphQLVariable("id")]], type: .list(.object(AllGroceryList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allGroceryLists: [AllGroceryList?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allGroceryLists": allGroceryLists.flatMap { (value: [AllGroceryList?]) -> [ResultMap?] in value.map { (value: AllGroceryList?) -> ResultMap? in value.flatMap { (value: AllGroceryList) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all GroceryList items which match the where clause.
    public var allGroceryLists: [AllGroceryList?]? {
      get {
        return (resultMap["allGroceryLists"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllGroceryList?] in value.map { (value: ResultMap?) -> AllGroceryList? in value.flatMap { (value: ResultMap) -> AllGroceryList in AllGroceryList(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllGroceryList?]) -> [ResultMap?] in value.map { (value: AllGroceryList?) -> ResultMap? in value.flatMap { (value: AllGroceryList) -> ResultMap in value.resultMap } } }, forKey: "allGroceryLists")
      }
    }

    public struct AllGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteGroceryListItemMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DELETE_GROCERY_LIST_ITEM($id: ID!) {
      deleteGroceryList(id: $id) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "DELETE_GROCERY_LIST_ITEM"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteGroceryList", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteGroceryList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteGroceryList: DeleteGroceryList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteGroceryList": deleteGroceryList.flatMap { (value: DeleteGroceryList) -> ResultMap in value.resultMap }])
    }

    /// Delete a single GroceryList item by ID.
    public var deleteGroceryList: DeleteGroceryList? {
      get {
        return (resultMap["deleteGroceryList"] as? ResultMap).flatMap { DeleteGroceryList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteGroceryList")
      }
    }

    public struct DeleteGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "GroceryList", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class CompleteGroceryListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation COMPLETE_GROCERY_LIST($id: ID!, $dateCompleted: DateTime, $isCompleted: Boolean) {
      updateGroceryList(
        id: $id
        data: {isCompleted: $isCompleted, dateCompleted: $dateCompleted}
      ) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "COMPLETE_GROCERY_LIST"

  public var id: GraphQLID
  public var dateCompleted: String?
  public var isCompleted: Bool?

  public init(id: GraphQLID, dateCompleted: String? = nil, isCompleted: Bool? = nil) {
    self.id = id
    self.dateCompleted = dateCompleted
    self.isCompleted = isCompleted
  }

  public var variables: GraphQLMap? {
    return ["id": id, "dateCompleted": dateCompleted, "isCompleted": isCompleted]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateGroceryList", arguments: ["id": GraphQLVariable("id"), "data": ["isCompleted": GraphQLVariable("isCompleted"), "dateCompleted": GraphQLVariable("dateCompleted")]], type: .object(UpdateGroceryList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateGroceryList: UpdateGroceryList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateGroceryList": updateGroceryList.flatMap { (value: UpdateGroceryList) -> ResultMap in value.resultMap }])
    }

    /// Update a single GroceryList item by ID.
    public var updateGroceryList: UpdateGroceryList? {
      get {
        return (resultMap["updateGroceryList"] as? ResultMap).flatMap { UpdateGroceryList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateGroceryList")
      }
    }

    public struct UpdateGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "GroceryList", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class AllMealsQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ALL_MEALS_QUERY($skip: Int = 0, $first: Int) {
      allMeals(first: $first, skip: $skip, sortBy: name_ASC) {
        __typename
        ...MealFragment
      }
    }
    """

  public let operationName: String = "ALL_MEALS_QUERY"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var skip: Int?
  public var first: Int?

  public init(skip: Int? = nil, first: Int? = nil) {
    self.skip = skip
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["skip": skip, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMeals", arguments: ["first": GraphQLVariable("first"), "skip": GraphQLVariable("skip"), "sortBy": "name_ASC"], type: .list(.object(AllMeal.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMeals: [AllMeal?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMeals": allMeals.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Meal items which match the where clause.
    public var allMeals: [AllMeal?]? {
      get {
        return (resultMap["allMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMeal?] in value.map { (value: ResultMap?) -> AllMeal? in value.flatMap { (value: ResultMap) -> AllMeal in AllMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }, forKey: "allMeals")
      }
    }

    public struct AllMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealFragment: MealFragment {
          get {
            return MealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class SearchForMealsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SEARCH_FOR_MEALS($searchText: String) {
      allMeals(where: {name_contains_i: $searchText}, sortBy: id_DESC) {
        __typename
        ...MealFragment
      }
    }
    """

  public let operationName: String = "SEARCH_FOR_MEALS"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var searchText: String?

  public init(searchText: String? = nil) {
    self.searchText = searchText
  }

  public var variables: GraphQLMap? {
    return ["searchText": searchText]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMeals", arguments: ["where": ["name_contains_i": GraphQLVariable("searchText")], "sortBy": "id_DESC"], type: .list(.object(AllMeal.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMeals: [AllMeal?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMeals": allMeals.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Meal items which match the where clause.
    public var allMeals: [AllMeal?]? {
      get {
        return (resultMap["allMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMeal?] in value.map { (value: ResultMap?) -> AllMeal? in value.flatMap { (value: ResultMap) -> AllMeal in AllMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }, forKey: "allMeals")
      }
    }

    public struct AllMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealFragment: MealFragment {
          get {
            return MealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MyMealsQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MY_MEALS_QUERY($authorId: ID!) {
      myMealToComplete: allMealLists(
        where: {author: {id: $authorId}, isCompleted: false}
      ) {
        __typename
        id
        isCompleted
        dateCompleted
        meal {
          __typename
          ...MealFragment
        }
      }
      myMealCompleted: allMealLists(
        where: {author: {id: $authorId}, isCompleted: true}
        sortBy: dateCompleted_DESC
      ) {
        __typename
        id
        isCompleted
        dateCompleted
        meal {
          __typename
          ...MealFragment
        }
      }
    }
    """

  public let operationName: String = "MY_MEALS_QUERY"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var authorId: GraphQLID

  public init(authorId: GraphQLID) {
    self.authorId = authorId
  }

  public var variables: GraphQLMap? {
    return ["authorId": authorId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMealLists", alias: "myMealToComplete", arguments: ["where": ["author": ["id": GraphQLVariable("authorId")], "isCompleted": false]], type: .list(.object(MyMealToComplete.selections))),
        GraphQLField("allMealLists", alias: "myMealCompleted", arguments: ["where": ["author": ["id": GraphQLVariable("authorId")], "isCompleted": true], "sortBy": "dateCompleted_DESC"], type: .list(.object(MyMealCompleted.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(myMealToComplete: [MyMealToComplete?]? = nil, myMealCompleted: [MyMealCompleted?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "myMealToComplete": myMealToComplete.flatMap { (value: [MyMealToComplete?]) -> [ResultMap?] in value.map { (value: MyMealToComplete?) -> ResultMap? in value.flatMap { (value: MyMealToComplete) -> ResultMap in value.resultMap } } }, "myMealCompleted": myMealCompleted.flatMap { (value: [MyMealCompleted?]) -> [ResultMap?] in value.map { (value: MyMealCompleted?) -> ResultMap? in value.flatMap { (value: MyMealCompleted) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all MealList items which match the where clause.
    public var myMealToComplete: [MyMealToComplete?]? {
      get {
        return (resultMap["myMealToComplete"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MyMealToComplete?] in value.map { (value: ResultMap?) -> MyMealToComplete? in value.flatMap { (value: ResultMap) -> MyMealToComplete in MyMealToComplete(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MyMealToComplete?]) -> [ResultMap?] in value.map { (value: MyMealToComplete?) -> ResultMap? in value.flatMap { (value: MyMealToComplete) -> ResultMap in value.resultMap } } }, forKey: "myMealToComplete")
      }
    }

    /// Search for all MealList items which match the where clause.
    public var myMealCompleted: [MyMealCompleted?]? {
      get {
        return (resultMap["myMealCompleted"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MyMealCompleted?] in value.map { (value: ResultMap?) -> MyMealCompleted? in value.flatMap { (value: ResultMap) -> MyMealCompleted in MyMealCompleted(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MyMealCompleted?]) -> [ResultMap?] in value.map { (value: MyMealCompleted?) -> ResultMap? in value.flatMap { (value: MyMealCompleted) -> ResultMap in value.resultMap } } }, forKey: "myMealCompleted")
      }
    }

    public struct MyMealToComplete: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("isCompleted", type: .scalar(Bool.self)),
          GraphQLField("dateCompleted", type: .scalar(String.self)),
          GraphQLField("meal", type: .object(Meal.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, isCompleted: Bool? = nil, dateCompleted: String? = nil, meal: Meal? = nil) {
        self.init(unsafeResultMap: ["__typename": "MealList", "id": id, "isCompleted": isCompleted, "dateCompleted": dateCompleted, "meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var isCompleted: Bool? {
        get {
          return resultMap["isCompleted"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCompleted")
        }
      }

      public var dateCompleted: String? {
        get {
          return resultMap["dateCompleted"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dateCompleted")
        }
      }

      public var meal: Meal? {
        get {
          return (resultMap["meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "meal")
        }
      }

      public struct Meal: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Meal"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(MealFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var mealFragment: MealFragment {
            get {
              return MealFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }

    public struct MyMealCompleted: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("isCompleted", type: .scalar(Bool.self)),
          GraphQLField("dateCompleted", type: .scalar(String.self)),
          GraphQLField("meal", type: .object(Meal.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, isCompleted: Bool? = nil, dateCompleted: String? = nil, meal: Meal? = nil) {
        self.init(unsafeResultMap: ["__typename": "MealList", "id": id, "isCompleted": isCompleted, "dateCompleted": dateCompleted, "meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var isCompleted: Bool? {
        get {
          return resultMap["isCompleted"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCompleted")
        }
      }

      public var dateCompleted: String? {
        get {
          return resultMap["dateCompleted"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dateCompleted")
        }
      }

      public var meal: Meal? {
        get {
          return (resultMap["meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "meal")
        }
      }

      public struct Meal: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Meal"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(MealFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var mealFragment: MealFragment {
            get {
              return MealFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class GetAllMealListsForQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_All_MEAL_LISTS_FOR($id: ID!) {
      allMealLists(where: {author: {id: $id}}) {
        __typename
        ...MealListFragment
      }
    }
    """

  public let operationName: String = "GET_All_MEAL_LISTS_FOR"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealListFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMealLists", arguments: ["where": ["author": ["id": GraphQLVariable("id")]]], type: .list(.object(AllMealList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMealLists: [AllMealList?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMealLists": allMealLists.flatMap { (value: [AllMealList?]) -> [ResultMap?] in value.map { (value: AllMealList?) -> ResultMap? in value.flatMap { (value: AllMealList) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all MealList items which match the where clause.
    public var allMealLists: [AllMealList?]? {
      get {
        return (resultMap["allMealLists"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMealList?] in value.map { (value: ResultMap?) -> AllMealList? in value.flatMap { (value: ResultMap) -> AllMealList in AllMealList(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMealList?]) -> [ResultMap?] in value.map { (value: AllMealList?) -> ResultMap? in value.flatMap { (value: AllMealList) -> ResultMap in value.resultMap } } }, forKey: "allMealLists")
      }
    }

    public struct AllMealList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealListFragment: MealListFragment {
          get {
            return MealListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CompleteMyMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation COMPLETE_MY_MEAL($id: ID!, $dateCompleted: DateTime, $isCompleted: Boolean) {
      updateMealList(
        id: $id
        data: {isCompleted: $isCompleted, dateCompleted: $dateCompleted}
      ) {
        __typename
        ...MealListFragment
      }
    }
    """

  public let operationName: String = "COMPLETE_MY_MEAL"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealListFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID
  public var dateCompleted: String?
  public var isCompleted: Bool?

  public init(id: GraphQLID, dateCompleted: String? = nil, isCompleted: Bool? = nil) {
    self.id = id
    self.dateCompleted = dateCompleted
    self.isCompleted = isCompleted
  }

  public var variables: GraphQLMap? {
    return ["id": id, "dateCompleted": dateCompleted, "isCompleted": isCompleted]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateMealList", arguments: ["id": GraphQLVariable("id"), "data": ["isCompleted": GraphQLVariable("isCompleted"), "dateCompleted": GraphQLVariable("dateCompleted")]], type: .object(UpdateMealList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateMealList: UpdateMealList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateMealList": updateMealList.flatMap { (value: UpdateMealList) -> ResultMap in value.resultMap }])
    }

    /// Update a single MealList item by ID.
    public var updateMealList: UpdateMealList? {
      get {
        return (resultMap["updateMealList"] as? ResultMap).flatMap { UpdateMealList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateMealList")
      }
    }

    public struct UpdateMealList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealListFragment: MealListFragment {
          get {
            return MealListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteMyMealListItemMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DELETE_MY_MEAL_LIST_ITEM($id: ID!) {
      deleteMealList(id: $id) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "DELETE_MY_MEAL_LIST_ITEM"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteMealList", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteMealList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteMealList: DeleteMealList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteMealList": deleteMealList.flatMap { (value: DeleteMealList) -> ResultMap in value.resultMap }])
    }

    /// Delete a single MealList item by ID.
    public var deleteMealList: DeleteMealList? {
      get {
        return (resultMap["deleteMealList"] as? ResultMap).flatMap { DeleteMealList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteMealList")
      }
    }

    public struct DeleteMealList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MealList", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class PaginationQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PAGINATION_QUERY {
      _allMealsMeta {
        __typename
        count
      }
    }
    """

  public let operationName: String = "PAGINATION_QUERY"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("_allMealsMeta", type: .object(_AllMealsMetum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_allMealsMeta: _AllMealsMetum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "_allMealsMeta": _allMealsMeta.flatMap { (value: _AllMealsMetum) -> ResultMap in value.resultMap }])
    }

    /// Perform a meta-query on all Meal items which match the where clause.
    public var _allMealsMeta: _AllMealsMetum? {
      get {
        return (resultMap["_allMealsMeta"] as? ResultMap).flatMap { _AllMealsMetum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "_allMealsMeta")
      }
    }

    public struct _AllMealsMetum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["_QueryMeta"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("count", type: .scalar(Int.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(count: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "_QueryMeta", "count": count])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var count: Int? {
        get {
          return resultMap["count"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "count")
        }
      }
    }
  }
}

public final class SigninMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SIGNIN_MUTATION($email: String!, $password: String!) {
      authenticateUserWithPassword(email: $email, password: $password) {
        __typename
        item {
          __typename
          id
          email
          name
        }
      }
    }
    """

  public let operationName: String = "SIGNIN_MUTATION"

  public var email: String
  public var password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authenticateUserWithPassword", arguments: ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")], type: .object(AuthenticateUserWithPassword.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authenticateUserWithPassword: AuthenticateUserWithPassword? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "authenticateUserWithPassword": authenticateUserWithPassword.flatMap { (value: AuthenticateUserWithPassword) -> ResultMap in value.resultMap }])
    }

    /// Authenticate and generate a token for a User with the Password Authentication Strategy.
    public var authenticateUserWithPassword: AuthenticateUserWithPassword? {
      get {
        return (resultMap["authenticateUserWithPassword"] as? ResultMap).flatMap { AuthenticateUserWithPassword(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "authenticateUserWithPassword")
      }
    }

    public struct AuthenticateUserWithPassword: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["authenticateUserOutput"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("item", type: .object(Item.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(item: Item? = nil) {
        self.init(unsafeResultMap: ["__typename": "authenticateUserOutput", "item": item.flatMap { (value: Item) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Retrieve information on the newly authenticated User here.
      public var item: Item? {
        get {
          return (resultMap["item"] as? ResultMap).flatMap { Item(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "item")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("email", type: .scalar(String.self)),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, email: String? = nil, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "email": email, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class SignOutMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SIGN_OUT_MUTATION {
      unauthenticateUser {
        __typename
        success
      }
    }
    """

  public let operationName: String = "SIGN_OUT_MUTATION"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("unauthenticateUser", type: .object(UnauthenticateUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(unauthenticateUser: UnauthenticateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "unauthenticateUser": unauthenticateUser.flatMap { (value: UnauthenticateUser) -> ResultMap in value.resultMap }])
    }

    public var unauthenticateUser: UnauthenticateUser? {
      get {
        return (resultMap["unauthenticateUser"] as? ResultMap).flatMap { UnauthenticateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "unauthenticateUser")
      }
    }

    public struct UnauthenticateUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["unauthenticateUserOutput"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("success", type: .scalar(Bool.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(success: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "unauthenticateUserOutput", "success": success])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// `true` when unauthentication succeeds.
      /// NOTE: unauthentication always succeeds when the request has an invalid or missing authentication token.
      public var success: Bool? {
        get {
          return resultMap["success"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "success")
        }
      }
    }
  }
}

public final class SignupMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SIGNUP_MUTATION($email: String!, $name: String!, $password: String!) {
      createUser(data: {email: $email, name: $name, password: $password}) {
        __typename
        id
        email
        name
      }
    }
    """

  public let operationName: String = "SIGNUP_MUTATION"

  public var email: String
  public var name: String
  public var password: String

  public init(email: String, name: String, password: String) {
    self.email = email
    self.name = name
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "name": name, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createUser", arguments: ["data": ["email": GraphQLVariable("email"), "name": GraphQLVariable("name"), "password": GraphQLVariable("password")]], type: .object(CreateUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createUser: CreateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createUser": createUser.flatMap { (value: CreateUser) -> ResultMap in value.resultMap }])
    }

    /// Create a single User item.
    public var createUser: CreateUser? {
      get {
        return (resultMap["createUser"] as? ResultMap).flatMap { CreateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("name", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, email: String? = nil, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "email": email, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class SingleMealQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SINGLE_MEAL_QUERY($id: ID!) {
      Meal(where: {id: $id}) {
        __typename
        id
        name
        description
        mealImage {
          __typename
          publicUrlTransformed
        }
        author {
          __typename
          id
        }
        ingredientList {
          __typename
          id
          ingredient {
            __typename
            id
            name
          }
          amount {
            __typename
            id
            name
          }
        }
      }
    }
    """

  public let operationName: String = "SINGLE_MEAL_QUERY"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Meal", arguments: ["where": ["id": GraphQLVariable("id")]], type: .object(Meal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(meal: Meal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
    }

    /// Search for the Meal item with the matching ID.
    public var meal: Meal? {
      get {
        return (resultMap["Meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Meal")
      }
    }

    public struct Meal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("mealImage", type: .object(MealImage.selections)),
          GraphQLField("author", type: .object(Author.selections)),
          GraphQLField("ingredientList", type: .nonNull(.list(.nonNull(.object(IngredientList.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, description: String? = nil, mealImage: MealImage? = nil, author: Author? = nil, ingredientList: [IngredientList]) {
        self.init(unsafeResultMap: ["__typename": "Meal", "id": id, "name": name, "description": description, "mealImage": mealImage.flatMap { (value: MealImage) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "ingredientList": ingredientList.map { (value: IngredientList) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var mealImage: MealImage? {
        get {
          return (resultMap["mealImage"] as? ResultMap).flatMap { MealImage(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "mealImage")
        }
      }

      public var author: Author? {
        get {
          return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "author")
        }
      }

      public var ingredientList: [IngredientList] {
        get {
          return (resultMap["ingredientList"] as! [ResultMap]).map { (value: ResultMap) -> IngredientList in IngredientList(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: IngredientList) -> ResultMap in value.resultMap }, forKey: "ingredientList")
        }
      }

      public struct MealImage: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CloudinaryImage_File"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("publicUrlTransformed", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(publicUrlTransformed: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "CloudinaryImage_File", "publicUrlTransformed": publicUrlTransformed])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var publicUrlTransformed: String? {
          get {
            return resultMap["publicUrlTransformed"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "publicUrlTransformed")
          }
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }

      public struct IngredientList: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MealIngredientList"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("ingredient", type: .object(Ingredient.selections)),
            GraphQLField("amount", type: .object(Amount.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, ingredient: Ingredient? = nil, amount: Amount? = nil) {
          self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id, "ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }, "amount": amount.flatMap { (value: Amount) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var ingredient: Ingredient? {
          get {
            return (resultMap["ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "ingredient")
          }
        }

        public var amount: Amount? {
          get {
            return (resultMap["amount"] as? ResultMap).flatMap { Amount(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "amount")
          }
        }

        public struct Ingredient: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Ingredient"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }

        public struct Amount: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Amount"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

public final class DeleteMealIngredientListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DELETE_MEAL_INGREDIENT_LIST($mealIngredientListId: ID!, $ingredientId: ID!, $mealId: ID!) {
      updateIngredient(id: $ingredientId, data: {meal: {disconnect: {id: $mealId}}}) {
        __typename
        id
      }
      deleteMealIngredientList(id: $mealIngredientListId) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "DELETE_MEAL_INGREDIENT_LIST"

  public var mealIngredientListId: GraphQLID
  public var ingredientId: GraphQLID
  public var mealId: GraphQLID

  public init(mealIngredientListId: GraphQLID, ingredientId: GraphQLID, mealId: GraphQLID) {
    self.mealIngredientListId = mealIngredientListId
    self.ingredientId = ingredientId
    self.mealId = mealId
  }

  public var variables: GraphQLMap? {
    return ["mealIngredientListId": mealIngredientListId, "ingredientId": ingredientId, "mealId": mealId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateIngredient", arguments: ["id": GraphQLVariable("ingredientId"), "data": ["meal": ["disconnect": ["id": GraphQLVariable("mealId")]]]], type: .object(UpdateIngredient.selections)),
        GraphQLField("deleteMealIngredientList", arguments: ["id": GraphQLVariable("mealIngredientListId")], type: .object(DeleteMealIngredientList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateIngredient: UpdateIngredient? = nil, deleteMealIngredientList: DeleteMealIngredientList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateIngredient": updateIngredient.flatMap { (value: UpdateIngredient) -> ResultMap in value.resultMap }, "deleteMealIngredientList": deleteMealIngredientList.flatMap { (value: DeleteMealIngredientList) -> ResultMap in value.resultMap }])
    }

    /// Update a single Ingredient item by ID.
    public var updateIngredient: UpdateIngredient? {
      get {
        return (resultMap["updateIngredient"] as? ResultMap).flatMap { UpdateIngredient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateIngredient")
      }
    }

    /// Delete a single MealIngredientList item by ID.
    public var deleteMealIngredientList: DeleteMealIngredientList? {
      get {
        return (resultMap["deleteMealIngredientList"] as? ResultMap).flatMap { DeleteMealIngredientList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteMealIngredientList")
      }
    }

    public struct UpdateIngredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }

    public struct DeleteMealIngredientList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealIngredientList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class AddMealToGroceryListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ADD_MEAL_TO_GROCERY_LIST($mealId: ID!, $authorId: ID!) {
      addMealToGroceryList(mealId: $mealId) {
        __typename
        ...GroceryListFragment
      }
      addMealToMealList: createMealList(
        data: {meal: {connect: {id: $mealId}}, author: {connect: {id: $authorId}}}
      ) {
        __typename
        ...MealListFragment
      }
    }
    """

  public let operationName: String = "ADD_MEAL_TO_GROCERY_LIST"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + MealListFragment.fragmentDefinition)
    return document
  }

  public var mealId: GraphQLID
  public var authorId: GraphQLID

  public init(mealId: GraphQLID, authorId: GraphQLID) {
    self.mealId = mealId
    self.authorId = authorId
  }

  public var variables: GraphQLMap? {
    return ["mealId": mealId, "authorId": authorId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addMealToGroceryList", arguments: ["mealId": GraphQLVariable("mealId")], type: .object(AddMealToGroceryList.selections)),
        GraphQLField("createMealList", alias: "addMealToMealList", arguments: ["data": ["meal": ["connect": ["id": GraphQLVariable("mealId")]], "author": ["connect": ["id": GraphQLVariable("authorId")]]]], type: .object(AddMealToMealList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addMealToGroceryList: AddMealToGroceryList? = nil, addMealToMealList: AddMealToMealList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addMealToGroceryList": addMealToGroceryList.flatMap { (value: AddMealToGroceryList) -> ResultMap in value.resultMap }, "addMealToMealList": addMealToMealList.flatMap { (value: AddMealToMealList) -> ResultMap in value.resultMap }])
    }

    public var addMealToGroceryList: AddMealToGroceryList? {
      get {
        return (resultMap["addMealToGroceryList"] as? ResultMap).flatMap { AddMealToGroceryList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addMealToGroceryList")
      }
    }

    /// Create a single MealList item.
    public var addMealToMealList: AddMealToMealList? {
      get {
        return (resultMap["addMealToMealList"] as? ResultMap).flatMap { AddMealToMealList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addMealToMealList")
      }
    }

    public struct AddMealToGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct AddMealToMealList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealListFragment: MealListFragment {
          get {
            return MealListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MadeMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation MADE_MEAL($mealId: ID!, $authorId: ID!, $dateMade: String) {
      createMadeMeal(
        data: {meal: {connect: {id: $mealId}}, author: {connect: {id: $authorId}}, dateMade: $dateMade}
      ) {
        __typename
        ...MadeMealFragment
      }
    }
    """

  public let operationName: String = "MADE_MEAL"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MadeMealFragment.fragmentDefinition)
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var mealId: GraphQLID
  public var authorId: GraphQLID
  public var dateMade: String?

  public init(mealId: GraphQLID, authorId: GraphQLID, dateMade: String? = nil) {
    self.mealId = mealId
    self.authorId = authorId
    self.dateMade = dateMade
  }

  public var variables: GraphQLMap? {
    return ["mealId": mealId, "authorId": authorId, "dateMade": dateMade]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createMadeMeal", arguments: ["data": ["meal": ["connect": ["id": GraphQLVariable("mealId")]], "author": ["connect": ["id": GraphQLVariable("authorId")]], "dateMade": GraphQLVariable("dateMade")]], type: .object(CreateMadeMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMadeMeal: CreateMadeMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMadeMeal": createMadeMeal.flatMap { (value: CreateMadeMeal) -> ResultMap in value.resultMap }])
    }

    /// Create a single MadeMeal item.
    public var createMadeMeal: CreateMadeMeal? {
      get {
        return (resultMap["createMadeMeal"] as? ResultMap).flatMap { CreateMadeMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createMadeMeal")
      }
    }

    public struct CreateMadeMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MadeMeal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MadeMealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var madeMealFragment: MadeMealFragment {
          get {
            return MadeMealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteMadeMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DELETE_MADE_MEAL($id: ID!) {
      deleteMadeMeal(id: $id) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "DELETE_MADE_MEAL"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteMadeMeal", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteMadeMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteMadeMeal: DeleteMadeMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteMadeMeal": deleteMadeMeal.flatMap { (value: DeleteMadeMeal) -> ResultMap in value.resultMap }])
    }

    /// Delete a single MadeMeal item by ID.
    public var deleteMadeMeal: DeleteMadeMeal? {
      get {
        return (resultMap["deleteMadeMeal"] as? ResultMap).flatMap { DeleteMadeMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteMadeMeal")
      }
    }

    public struct DeleteMadeMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MadeMeal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MadeMeal", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class UpdateMadeMealMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UPDATE_MADE_MEAL($id: ID!, $thoughts: String, $dateMade: String) {
      updateMadeMeal(id: $id, data: {thoughts: $thoughts, dateMade: $dateMade}) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "UPDATE_MADE_MEAL"

  public var id: GraphQLID
  public var thoughts: String?
  public var dateMade: String?

  public init(id: GraphQLID, thoughts: String? = nil, dateMade: String? = nil) {
    self.id = id
    self.thoughts = thoughts
    self.dateMade = dateMade
  }

  public var variables: GraphQLMap? {
    return ["id": id, "thoughts": thoughts, "dateMade": dateMade]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateMadeMeal", arguments: ["id": GraphQLVariable("id"), "data": ["thoughts": GraphQLVariable("thoughts"), "dateMade": GraphQLVariable("dateMade")]], type: .object(UpdateMadeMeal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateMadeMeal: UpdateMadeMeal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateMadeMeal": updateMadeMeal.flatMap { (value: UpdateMadeMeal) -> ResultMap in value.resultMap }])
    }

    /// Update a single MadeMeal item by ID.
    public var updateMadeMeal: UpdateMadeMeal? {
      get {
        return (resultMap["updateMadeMeal"] as? ResultMap).flatMap { UpdateMadeMeal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateMadeMeal")
      }
    }

    public struct UpdateMadeMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MadeMeal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "MadeMeal", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class GetMadeMealsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_MADE_MEALS($ids: [ID!], $mealId: ID!) {
      allMadeMeals(
        where: {author: {id_in: $ids}, meal: {id: $mealId}}
        sortBy: dateMade_DESC
      ) {
        __typename
        ...MadeMealFragment
      }
    }
    """

  public let operationName: String = "GET_MADE_MEALS"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MadeMealFragment.fragmentDefinition)
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var ids: [GraphQLID]?
  public var mealId: GraphQLID

  public init(ids: [GraphQLID]?, mealId: GraphQLID) {
    self.ids = ids
    self.mealId = mealId
  }

  public var variables: GraphQLMap? {
    return ["ids": ids, "mealId": mealId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMadeMeals", arguments: ["where": ["author": ["id_in": GraphQLVariable("ids")], "meal": ["id": GraphQLVariable("mealId")]], "sortBy": "dateMade_DESC"], type: .list(.object(AllMadeMeal.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMadeMeals: [AllMadeMeal?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMadeMeals": allMadeMeals.flatMap { (value: [AllMadeMeal?]) -> [ResultMap?] in value.map { (value: AllMadeMeal?) -> ResultMap? in value.flatMap { (value: AllMadeMeal) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all MadeMeal items which match the where clause.
    public var allMadeMeals: [AllMadeMeal?]? {
      get {
        return (resultMap["allMadeMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMadeMeal?] in value.map { (value: ResultMap?) -> AllMadeMeal? in value.flatMap { (value: ResultMap) -> AllMadeMeal in AllMadeMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMadeMeal?]) -> [ResultMap?] in value.map { (value: AllMadeMeal?) -> ResultMap? in value.flatMap { (value: AllMadeMeal) -> ResultMap in value.resultMap } } }, forKey: "allMadeMeals")
      }
    }

    public struct AllMadeMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MadeMeal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MadeMealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var madeMealFragment: MadeMealFragment {
          get {
            return MadeMealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class SingleMealUpdateQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SINGLE_MEAL_UPDATE_QUERY($id: ID!) {
      Meal(where: {id: $id}) {
        __typename
        id
        name
        description
      }
    }
    """

  public let operationName: String = "SINGLE_MEAL_UPDATE_QUERY"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Meal", arguments: ["where": ["id": GraphQLVariable("id")]], type: .object(Meal.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(meal: Meal? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
    }

    /// Search for the Meal item with the matching ID.
    public var meal: Meal? {
      get {
        return (resultMap["Meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Meal")
      }
    }

    public struct Meal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, description: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Meal", "id": id, "name": name, "description": description])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }
    }
  }
}

public final class CurrentUserQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query CURRENT_USER_QUERY {
      authenticatedUser {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "CURRENT_USER_QUERY"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authenticatedUser", type: .object(AuthenticatedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authenticatedUser: AuthenticatedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "authenticatedUser": authenticatedUser.flatMap { (value: AuthenticatedUser) -> ResultMap in value.resultMap }])
    }

    public var authenticatedUser: AuthenticatedUser? {
      get {
        return (resultMap["authenticatedUser"] as? ResultMap).flatMap { AuthenticatedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "authenticatedUser")
      }
    }

    public struct AuthenticatedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AuthenticateUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AUTHENTICATE_USER($email: String!, $password: String) {
      authenticateUserWithPassword(email: $email, password: $password) {
        __typename
        token
        item {
          __typename
          id
          email
        }
      }
    }
    """

  public let operationName: String = "AUTHENTICATE_USER"

  public var email: String
  public var password: String?

  public init(email: String, password: String? = nil) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authenticateUserWithPassword", arguments: ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")], type: .object(AuthenticateUserWithPassword.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authenticateUserWithPassword: AuthenticateUserWithPassword? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "authenticateUserWithPassword": authenticateUserWithPassword.flatMap { (value: AuthenticateUserWithPassword) -> ResultMap in value.resultMap }])
    }

    /// Authenticate and generate a token for a User with the Password Authentication Strategy.
    public var authenticateUserWithPassword: AuthenticateUserWithPassword? {
      get {
        return (resultMap["authenticateUserWithPassword"] as? ResultMap).flatMap { AuthenticateUserWithPassword(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "authenticateUserWithPassword")
      }
    }

    public struct AuthenticateUserWithPassword: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["authenticateUserOutput"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("item", type: .object(Item.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String? = nil, item: Item? = nil) {
        self.init(unsafeResultMap: ["__typename": "authenticateUserOutput", "token": token, "item": item.flatMap { (value: Item) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Used to make subsequent authenticated requests by setting this token in a header: 'Authorization: Bearer <token>'.
      public var token: String? {
        get {
          return resultMap["token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      /// Retrieve information on the newly authenticated User here.
      public var item: Item? {
        get {
          return (resultMap["item"] as? ResultMap).flatMap { Item(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "item")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("email", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, email: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "email": email])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }
      }
    }
  }
}

public final class IsAuthenticatedUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query IS_AUTHENTICATED_USER {
      authenticatedUser {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "IS_AUTHENTICATED_USER"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("authenticatedUser", type: .object(AuthenticatedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(authenticatedUser: AuthenticatedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "authenticatedUser": authenticatedUser.flatMap { (value: AuthenticatedUser) -> ResultMap in value.resultMap }])
    }

    public var authenticatedUser: AuthenticatedUser? {
      get {
        return (resultMap["authenticatedUser"] as? ResultMap).flatMap { AuthenticatedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "authenticatedUser")
      }
    }

    public struct AuthenticatedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetIngredientInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GET_INGREDIENT_INFO($id: ID!) {
      Ingredient(where: {id: $id}) {
        __typename
        name
        category
        meal {
          __typename
          ...MealFragment
        }
      }
    }
    """

  public let operationName: String = "GET_INGREDIENT_INFO"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Ingredient", arguments: ["where": ["id": GraphQLVariable("id")]], type: .object(Ingredient.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ingredient: Ingredient? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }])
    }

    /// Search for the Ingredient item with the matching ID.
    public var ingredient: Ingredient? {
      get {
        return (resultMap["Ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Ingredient")
      }
    }

    public struct Ingredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("category", type: .scalar(Int.self)),
          GraphQLField("meal", type: .nonNull(.list(.nonNull(.object(Meal.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String? = nil, category: Int? = nil, meal: [Meal]) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "name": name, "category": category, "meal": meal.map { (value: Meal) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var category: Int? {
        get {
          return resultMap["category"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "category")
        }
      }

      public var meal: [Meal] {
        get {
          return (resultMap["meal"] as! [ResultMap]).map { (value: ResultMap) -> Meal in Meal(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Meal) -> ResultMap in value.resultMap }, forKey: "meal")
        }
      }

      public struct Meal: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Meal"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(MealFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var mealFragment: MealFragment {
            get {
              return MealFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class AllUsersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ALL_USERS {
      allUsers {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "ALL_USERS"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allUsers", type: .list(.object(AllUser.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allUsers: [AllUser?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allUsers": allUsers.flatMap { (value: [AllUser?]) -> [ResultMap?] in value.map { (value: AllUser?) -> ResultMap? in value.flatMap { (value: AllUser) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all User items which match the where clause.
    public var allUsers: [AllUser?]? {
      get {
        return (resultMap["allUsers"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllUser?] in value.map { (value: ResultMap?) -> AllUser? in value.flatMap { (value: ResultMap) -> AllUser in AllUser(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllUser?]) -> [ResultMap?] in value.map { (value: AllUser?) -> ResultMap? in value.flatMap { (value: AllUser) -> ResultMap in value.resultMap } } }, forKey: "allUsers")
      }
    }

    public struct AllUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class StartFollowingMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation START_FOLLOWING($id_to_change_following: ID!, $current_user: ID!) {
      startFollowUser: updateUser(
        id: $current_user
        data: {follows: {connect: {id: $id_to_change_following}}}
      ) {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "START_FOLLOWING"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var id_to_change_following: GraphQLID
  public var current_user: GraphQLID

  public init(id_to_change_following: GraphQLID, current_user: GraphQLID) {
    self.id_to_change_following = id_to_change_following
    self.current_user = current_user
  }

  public var variables: GraphQLMap? {
    return ["id_to_change_following": id_to_change_following, "current_user": current_user]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateUser", alias: "startFollowUser", arguments: ["id": GraphQLVariable("current_user"), "data": ["follows": ["connect": ["id": GraphQLVariable("id_to_change_following")]]]], type: .object(StartFollowUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(startFollowUser: StartFollowUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "startFollowUser": startFollowUser.flatMap { (value: StartFollowUser) -> ResultMap in value.resultMap }])
    }

    /// Update a single User item by ID.
    public var startFollowUser: StartFollowUser? {
      get {
        return (resultMap["startFollowUser"] as? ResultMap).flatMap { StartFollowUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "startFollowUser")
      }
    }

    public struct StartFollowUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class StopFollowingMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation STOP_FOLLOWING($id_to_change_following: ID!, $current_user: ID!) {
      stopFollowUser: updateUser(
        id: $current_user
        data: {follows: {disconnect: {id: $id_to_change_following}}}
      ) {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "STOP_FOLLOWING"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var id_to_change_following: GraphQLID
  public var current_user: GraphQLID

  public init(id_to_change_following: GraphQLID, current_user: GraphQLID) {
    self.id_to_change_following = id_to_change_following
    self.current_user = current_user
  }

  public var variables: GraphQLMap? {
    return ["id_to_change_following": id_to_change_following, "current_user": current_user]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateUser", alias: "stopFollowUser", arguments: ["id": GraphQLVariable("current_user"), "data": ["follows": ["disconnect": ["id": GraphQLVariable("id_to_change_following")]]]], type: .object(StopFollowUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(stopFollowUser: StopFollowUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "stopFollowUser": stopFollowUser.flatMap { (value: StopFollowUser) -> ResultMap in value.resultMap }])
    }

    /// Update a single User item by ID.
    public var stopFollowUser: StopFollowUser? {
      get {
        return (resultMap["stopFollowUser"] as? ResultMap).flatMap { StopFollowUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "stopFollowUser")
      }
    }

    public struct StopFollowUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AllMealsQuerySocialQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ALL_MEALS_QUERY_SOCIAL($ids: [ID!]) {
      allMeals(where: {author: {id_in: $ids}}, sortBy: createdAt_DESC) {
        __typename
        ...MealFragment
      }
      allMadeMeals(where: {author: {id_in: $ids}}, sortBy: dateMade_DESC) {
        __typename
        ...MadeMealFragment
      }
    }
    """

  public let operationName: String = "ALL_MEALS_QUERY_SOCIAL"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealFragment.fragmentDefinition)
    document.append("\n" + MadeMealFragment.fragmentDefinition)
    return document
  }

  public var ids: [GraphQLID]?

  public init(ids: [GraphQLID]?) {
    self.ids = ids
  }

  public var variables: GraphQLMap? {
    return ["ids": ids]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allMeals", arguments: ["where": ["author": ["id_in": GraphQLVariable("ids")]], "sortBy": "createdAt_DESC"], type: .list(.object(AllMeal.selections))),
        GraphQLField("allMadeMeals", arguments: ["where": ["author": ["id_in": GraphQLVariable("ids")]], "sortBy": "dateMade_DESC"], type: .list(.object(AllMadeMeal.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMeals: [AllMeal?]? = nil, allMadeMeals: [AllMadeMeal?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMeals": allMeals.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }, "allMadeMeals": allMadeMeals.flatMap { (value: [AllMadeMeal?]) -> [ResultMap?] in value.map { (value: AllMadeMeal?) -> ResultMap? in value.flatMap { (value: AllMadeMeal) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Meal items which match the where clause.
    public var allMeals: [AllMeal?]? {
      get {
        return (resultMap["allMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMeal?] in value.map { (value: ResultMap?) -> AllMeal? in value.flatMap { (value: ResultMap) -> AllMeal in AllMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMeal?]) -> [ResultMap?] in value.map { (value: AllMeal?) -> ResultMap? in value.flatMap { (value: AllMeal) -> ResultMap in value.resultMap } } }, forKey: "allMeals")
      }
    }

    /// Search for all MadeMeal items which match the where clause.
    public var allMadeMeals: [AllMadeMeal?]? {
      get {
        return (resultMap["allMadeMeals"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllMadeMeal?] in value.map { (value: ResultMap?) -> AllMadeMeal? in value.flatMap { (value: ResultMap) -> AllMadeMeal in AllMadeMeal(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllMadeMeal?]) -> [ResultMap?] in value.map { (value: AllMadeMeal?) -> ResultMap? in value.flatMap { (value: AllMadeMeal) -> ResultMap in value.resultMap } } }, forKey: "allMadeMeals")
      }
    }

    public struct AllMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Meal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealFragment: MealFragment {
          get {
            return MealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct AllMadeMeal: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MadeMeal"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MadeMealFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var madeMealFragment: MadeMealFragment {
          get {
            return MadeMealFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateAmountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_AMOUNT($name: String) {
      createAmount(data: {name: $name}) {
        __typename
        ...AmountFragment
      }
    }
    """

  public let operationName: String = "CREATE_AMOUNT"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var name: String?

  public init(name: String? = nil) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createAmount", arguments: ["data": ["name": GraphQLVariable("name")]], type: .object(CreateAmount.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createAmount: CreateAmount? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createAmount": createAmount.flatMap { (value: CreateAmount) -> ResultMap in value.resultMap }])
    }

    /// Create a single Amount item.
    public var createAmount: CreateAmount? {
      get {
        return (resultMap["createAmount"] as? ResultMap).flatMap { CreateAmount(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createAmount")
      }
    }

    public struct CreateAmount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Amount"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AmountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var amountFragment: AmountFragment {
          get {
            return AmountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateIngredientMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_INGREDIENT($name: String) {
      createIngredient(data: {name: $name}) {
        __typename
        ...IngredientFragment
      }
    }
    """

  public let operationName: String = "CREATE_INGREDIENT"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + IngredientFragment.fragmentDefinition)
    return document
  }

  public var name: String?

  public init(name: String? = nil) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createIngredient", arguments: ["data": ["name": GraphQLVariable("name")]], type: .object(CreateIngredient.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createIngredient: CreateIngredient? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createIngredient": createIngredient.flatMap { (value: CreateIngredient) -> ResultMap in value.resultMap }])
    }

    /// Create a single Ingredient item.
    public var createIngredient: CreateIngredient? {
      get {
        return (resultMap["createIngredient"] as? ResultMap).flatMap { CreateIngredient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createIngredient")
      }
    }

    public struct CreateIngredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(IngredientFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var ingredientFragment: IngredientFragment {
          get {
            return IngredientFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateIngredientAndAmountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_INGREDIENT_AND_AMOUNT($ingredientName: String, $amountName: String) {
      createIngredient(data: {name: $ingredientName}) {
        __typename
        ...IngredientFragment
      }
      createAmount(data: {name: $amountName}) {
        __typename
        ...AmountFragment
      }
    }
    """

  public let operationName: String = "CREATE_INGREDIENT_AND_AMOUNT"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var ingredientName: String?
  public var amountName: String?

  public init(ingredientName: String? = nil, amountName: String? = nil) {
    self.ingredientName = ingredientName
    self.amountName = amountName
  }

  public var variables: GraphQLMap? {
    return ["ingredientName": ingredientName, "amountName": amountName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createIngredient", arguments: ["data": ["name": GraphQLVariable("ingredientName")]], type: .object(CreateIngredient.selections)),
        GraphQLField("createAmount", arguments: ["data": ["name": GraphQLVariable("amountName")]], type: .object(CreateAmount.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createIngredient: CreateIngredient? = nil, createAmount: CreateAmount? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createIngredient": createIngredient.flatMap { (value: CreateIngredient) -> ResultMap in value.resultMap }, "createAmount": createAmount.flatMap { (value: CreateAmount) -> ResultMap in value.resultMap }])
    }

    /// Create a single Ingredient item.
    public var createIngredient: CreateIngredient? {
      get {
        return (resultMap["createIngredient"] as? ResultMap).flatMap { CreateIngredient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createIngredient")
      }
    }

    /// Create a single Amount item.
    public var createAmount: CreateAmount? {
      get {
        return (resultMap["createAmount"] as? ResultMap).flatMap { CreateAmount(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createAmount")
      }
    }

    public struct CreateIngredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(IngredientFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var ingredientFragment: IngredientFragment {
          get {
            return IngredientFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct CreateAmount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Amount"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AmountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var amountFragment: AmountFragment {
          get {
            return AmountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateGrocerylistItemMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_GROCERYLIST_ITEM($ingredientId: ID!, $amountId: ID!, $userId: ID!) {
      createGroceryList(
        data: {ingredient: {connect: {id: $ingredientId}}, amount: {connect: {id: $amountId}}, author: {connect: {id: $userId}}}
      ) {
        __typename
        ...GroceryListFragment
      }
    }
    """

  public let operationName: String = "CREATE_GROCERYLIST_ITEM"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + GroceryListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + MealDemoFragment.fragmentDefinition)
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    return document
  }

  public var ingredientId: GraphQLID
  public var amountId: GraphQLID
  public var userId: GraphQLID

  public init(ingredientId: GraphQLID, amountId: GraphQLID, userId: GraphQLID) {
    self.ingredientId = ingredientId
    self.amountId = amountId
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["ingredientId": ingredientId, "amountId": amountId, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createGroceryList", arguments: ["data": ["ingredient": ["connect": ["id": GraphQLVariable("ingredientId")]], "amount": ["connect": ["id": GraphQLVariable("amountId")]], "author": ["connect": ["id": GraphQLVariable("userId")]]]], type: .object(CreateGroceryList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createGroceryList: CreateGroceryList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createGroceryList": createGroceryList.flatMap { (value: CreateGroceryList) -> ResultMap in value.resultMap }])
    }

    /// Create a single GroceryList item.
    public var createGroceryList: CreateGroceryList? {
      get {
        return (resultMap["createGroceryList"] as? ResultMap).flatMap { CreateGroceryList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createGroceryList")
      }
    }

    public struct CreateGroceryList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GroceryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(GroceryListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var groceryListFragment: GroceryListFragment {
          get {
            return GroceryListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AllAmountsAndIngredientsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ALL_AMOUNTS_AND_INGREDIENTS {
      allAmounts {
        __typename
        ...AmountFragment
      }
      allIngredients {
        __typename
        ...IngredientFragment
      }
    }
    """

  public let operationName: String = "ALL_AMOUNTS_AND_INGREDIENTS"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AmountFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allAmounts", type: .list(.object(AllAmount.selections))),
        GraphQLField("allIngredients", type: .list(.object(AllIngredient.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allAmounts: [AllAmount?]? = nil, allIngredients: [AllIngredient?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allAmounts": allAmounts.flatMap { (value: [AllAmount?]) -> [ResultMap?] in value.map { (value: AllAmount?) -> ResultMap? in value.flatMap { (value: AllAmount) -> ResultMap in value.resultMap } } }, "allIngredients": allIngredients.flatMap { (value: [AllIngredient?]) -> [ResultMap?] in value.map { (value: AllIngredient?) -> ResultMap? in value.flatMap { (value: AllIngredient) -> ResultMap in value.resultMap } } }])
    }

    /// Search for all Amount items which match the where clause.
    public var allAmounts: [AllAmount?]? {
      get {
        return (resultMap["allAmounts"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllAmount?] in value.map { (value: ResultMap?) -> AllAmount? in value.flatMap { (value: ResultMap) -> AllAmount in AllAmount(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllAmount?]) -> [ResultMap?] in value.map { (value: AllAmount?) -> ResultMap? in value.flatMap { (value: AllAmount) -> ResultMap in value.resultMap } } }, forKey: "allAmounts")
      }
    }

    /// Search for all Ingredient items which match the where clause.
    public var allIngredients: [AllIngredient?]? {
      get {
        return (resultMap["allIngredients"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [AllIngredient?] in value.map { (value: ResultMap?) -> AllIngredient? in value.flatMap { (value: ResultMap) -> AllIngredient in AllIngredient(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllIngredient?]) -> [ResultMap?] in value.map { (value: AllIngredient?) -> ResultMap? in value.flatMap { (value: AllIngredient) -> ResultMap in value.resultMap } } }, forKey: "allIngredients")
      }
    }

    public struct AllAmount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Amount"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AmountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var amountFragment: AmountFragment {
          get {
            return AmountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct AllIngredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(IngredientFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var ingredientFragment: IngredientFragment {
          get {
            return IngredientFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateMealIngredientListMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CREATE_MEAL_INGREDIENT_LIST($mealId: ID!, $ingredientId: ID!, $amountId: ID!) {
      createMealIngredientList(
        data: {meal: {connect: {id: $mealId}}, ingredient: {connect: {id: $ingredientId}}, amount: {connect: {id: $amountId}}}
      ) {
        __typename
        ...MealIngredientListFragment
      }
    }
    """

  public let operationName: String = "CREATE_MEAL_INGREDIENT_LIST"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MealIngredientListFragment.fragmentDefinition)
    document.append("\n" + IngredientFragment.fragmentDefinition)
    document.append("\n" + AmountFragment.fragmentDefinition)
    return document
  }

  public var mealId: GraphQLID
  public var ingredientId: GraphQLID
  public var amountId: GraphQLID

  public init(mealId: GraphQLID, ingredientId: GraphQLID, amountId: GraphQLID) {
    self.mealId = mealId
    self.ingredientId = ingredientId
    self.amountId = amountId
  }

  public var variables: GraphQLMap? {
    return ["mealId": mealId, "ingredientId": ingredientId, "amountId": amountId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createMealIngredientList", arguments: ["data": ["meal": ["connect": ["id": GraphQLVariable("mealId")]], "ingredient": ["connect": ["id": GraphQLVariable("ingredientId")]], "amount": ["connect": ["id": GraphQLVariable("amountId")]]]], type: .object(CreateMealIngredientList.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMealIngredientList: CreateMealIngredientList? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMealIngredientList": createMealIngredientList.flatMap { (value: CreateMealIngredientList) -> ResultMap in value.resultMap }])
    }

    /// Create a single MealIngredientList item.
    public var createMealIngredientList: CreateMealIngredientList? {
      get {
        return (resultMap["createMealIngredientList"] as? ResultMap).flatMap { CreateMealIngredientList(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createMealIngredientList")
      }
    }

    public struct CreateMealIngredientList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MealIngredientList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MealIngredientListFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var mealIngredientListFragment: MealIngredientListFragment {
          get {
            return MealIngredientListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct MealFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MealFragment on Meal {
      __typename
      id
      name
      description
      createdAt
      mealImage {
        __typename
        publicUrlTransformed
      }
      author {
        __typename
        id
      }
      ingredientList {
        __typename
        id
        ingredient {
          __typename
          id
          name
        }
        amount {
          __typename
          id
          name
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["Meal"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .scalar(String.self)),
      GraphQLField("mealImage", type: .object(MealImage.selections)),
      GraphQLField("author", type: .object(Author.selections)),
      GraphQLField("ingredientList", type: .nonNull(.list(.nonNull(.object(IngredientList.selections))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, description: String? = nil, createdAt: String? = nil, mealImage: MealImage? = nil, author: Author? = nil, ingredientList: [IngredientList]) {
    self.init(unsafeResultMap: ["__typename": "Meal", "id": id, "name": name, "description": description, "createdAt": createdAt, "mealImage": mealImage.flatMap { (value: MealImage) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "ingredientList": ingredientList.map { (value: IngredientList) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var createdAt: String? {
    get {
      return resultMap["createdAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var mealImage: MealImage? {
    get {
      return (resultMap["mealImage"] as? ResultMap).flatMap { MealImage(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "mealImage")
    }
  }

  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  public var ingredientList: [IngredientList] {
    get {
      return (resultMap["ingredientList"] as! [ResultMap]).map { (value: ResultMap) -> IngredientList in IngredientList(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: IngredientList) -> ResultMap in value.resultMap }, forKey: "ingredientList")
    }
  }

  public struct MealImage: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["CloudinaryImage_File"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicUrlTransformed", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(publicUrlTransformed: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "CloudinaryImage_File", "publicUrlTransformed": publicUrlTransformed])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var publicUrlTransformed: String? {
      get {
        return resultMap["publicUrlTransformed"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "publicUrlTransformed")
      }
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }

  public struct IngredientList: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["MealIngredientList"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("ingredient", type: .object(Ingredient.selections)),
        GraphQLField("amount", type: .object(Amount.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, ingredient: Ingredient? = nil, amount: Amount? = nil) {
      self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id, "ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }, "amount": amount.flatMap { (value: Amount) -> ResultMap in value.resultMap }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var ingredient: Ingredient? {
      get {
        return (resultMap["ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ingredient")
      }
    }

    public var amount: Amount? {
      get {
        return (resultMap["amount"] as? ResultMap).flatMap { Amount(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "amount")
      }
    }

    public struct Ingredient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ingredient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }

    public struct Amount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Amount"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public struct MealIngredientListFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MealIngredientListFragment on MealIngredientList {
      __typename
      id
      ingredient {
        __typename
        ...IngredientFragment
      }
      amount {
        __typename
        ...AmountFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["MealIngredientList"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("ingredient", type: .object(Ingredient.selections)),
      GraphQLField("amount", type: .object(Amount.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, ingredient: Ingredient? = nil, amount: Amount? = nil) {
    self.init(unsafeResultMap: ["__typename": "MealIngredientList", "id": id, "ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }, "amount": amount.flatMap { (value: Amount) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var ingredient: Ingredient? {
    get {
      return (resultMap["ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "ingredient")
    }
  }

  public var amount: Amount? {
    get {
      return (resultMap["amount"] as? ResultMap).flatMap { Amount(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "amount")
    }
  }

  public struct Ingredient: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Ingredient"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(IngredientFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var ingredientFragment: IngredientFragment {
        get {
          return IngredientFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Amount: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Amount"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AmountFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var amountFragment: AmountFragment {
        get {
          return AmountFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct MealDemoFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MealDemoFragment on Meal {
      __typename
      id
      name
      description
      mealImage {
        __typename
        publicUrlTransformed
      }
      ingredientList {
        __typename
        ...MealIngredientListFragment
      }
      author {
        __typename
        id
      }
    }
    """

  public static let possibleTypes: [String] = ["Meal"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("mealImage", type: .object(MealImage.selections)),
      GraphQLField("ingredientList", type: .nonNull(.list(.nonNull(.object(IngredientList.selections))))),
      GraphQLField("author", type: .object(Author.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, description: String? = nil, mealImage: MealImage? = nil, ingredientList: [IngredientList], author: Author? = nil) {
    self.init(unsafeResultMap: ["__typename": "Meal", "id": id, "name": name, "description": description, "mealImage": mealImage.flatMap { (value: MealImage) -> ResultMap in value.resultMap }, "ingredientList": ingredientList.map { (value: IngredientList) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var mealImage: MealImage? {
    get {
      return (resultMap["mealImage"] as? ResultMap).flatMap { MealImage(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "mealImage")
    }
  }

  public var ingredientList: [IngredientList] {
    get {
      return (resultMap["ingredientList"] as! [ResultMap]).map { (value: ResultMap) -> IngredientList in IngredientList(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: IngredientList) -> ResultMap in value.resultMap }, forKey: "ingredientList")
    }
  }

  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  public struct MealImage: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["CloudinaryImage_File"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicUrlTransformed", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(publicUrlTransformed: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "CloudinaryImage_File", "publicUrlTransformed": publicUrlTransformed])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var publicUrlTransformed: String? {
      get {
        return resultMap["publicUrlTransformed"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "publicUrlTransformed")
      }
    }
  }

  public struct IngredientList: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["MealIngredientList"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MealIngredientListFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var mealIngredientListFragment: MealIngredientListFragment {
        get {
          return MealIngredientListFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }
}

public struct GroceryListFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment GroceryListFragment on GroceryList {
      __typename
      id
      author {
        __typename
        id
      }
      ingredient {
        __typename
        ...IngredientFragment
      }
      amount {
        __typename
        ...AmountFragment
      }
      meal {
        __typename
        ...MealDemoFragment
      }
      isCompleted
      dateCompleted
    }
    """

  public static let possibleTypes: [String] = ["GroceryList"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("author", type: .object(Author.selections)),
      GraphQLField("ingredient", type: .object(Ingredient.selections)),
      GraphQLField("amount", type: .object(Amount.selections)),
      GraphQLField("meal", type: .object(Meal.selections)),
      GraphQLField("isCompleted", type: .scalar(Bool.self)),
      GraphQLField("dateCompleted", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, author: Author? = nil, ingredient: Ingredient? = nil, amount: Amount? = nil, meal: Meal? = nil, isCompleted: Bool? = nil, dateCompleted: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "GroceryList", "id": id, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "ingredient": ingredient.flatMap { (value: Ingredient) -> ResultMap in value.resultMap }, "amount": amount.flatMap { (value: Amount) -> ResultMap in value.resultMap }, "meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }, "isCompleted": isCompleted, "dateCompleted": dateCompleted])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  public var ingredient: Ingredient? {
    get {
      return (resultMap["ingredient"] as? ResultMap).flatMap { Ingredient(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "ingredient")
    }
  }

  public var amount: Amount? {
    get {
      return (resultMap["amount"] as? ResultMap).flatMap { Amount(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "amount")
    }
  }

  public var meal: Meal? {
    get {
      return (resultMap["meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "meal")
    }
  }

  public var isCompleted: Bool? {
    get {
      return resultMap["isCompleted"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isCompleted")
    }
  }

  public var dateCompleted: String? {
    get {
      return resultMap["dateCompleted"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "dateCompleted")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }

  public struct Ingredient: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Ingredient"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(IngredientFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var ingredientFragment: IngredientFragment {
        get {
          return IngredientFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Amount: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Amount"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AmountFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var amountFragment: AmountFragment {
        get {
          return AmountFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Meal: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Meal"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MealDemoFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var mealDemoFragment: MealDemoFragment {
        get {
          return MealDemoFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct IngredientFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment IngredientFragment on Ingredient {
      __typename
      id
      name
      category
    }
    """

  public static let possibleTypes: [String] = ["Ingredient"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("category", type: .scalar(Int.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, category: Int? = nil) {
    self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "category": category])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var category: Int? {
    get {
      return resultMap["category"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "category")
    }
  }
}

public struct AmountFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AmountFragment on Amount {
      __typename
      id
      name
    }
    """

  public static let possibleTypes: [String] = ["Amount"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Amount", "id": id, "name": name])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }
}

public struct MealListFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MealListFragment on MealList {
      __typename
      id
      author {
        __typename
        id
      }
      isCompleted
      dateCompleted
      meal {
        __typename
        ...MealDemoFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["MealList"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("author", type: .object(Author.selections)),
      GraphQLField("isCompleted", type: .scalar(Bool.self)),
      GraphQLField("dateCompleted", type: .scalar(String.self)),
      GraphQLField("meal", type: .object(Meal.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, author: Author? = nil, isCompleted: Bool? = nil, dateCompleted: String? = nil, meal: Meal? = nil) {
    self.init(unsafeResultMap: ["__typename": "MealList", "id": id, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "isCompleted": isCompleted, "dateCompleted": dateCompleted, "meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  public var isCompleted: Bool? {
    get {
      return resultMap["isCompleted"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isCompleted")
    }
  }

  public var dateCompleted: String? {
    get {
      return resultMap["dateCompleted"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "dateCompleted")
    }
  }

  public var meal: Meal? {
    get {
      return (resultMap["meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "meal")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }

  public struct Meal: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Meal"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MealDemoFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var mealDemoFragment: MealDemoFragment {
        get {
          return MealDemoFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct MadeMealFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MadeMealFragment on MadeMeal {
      __typename
      id
      dateMade
      thoughts
      ingredientImage {
        __typename
        publicUrlTransformed
      }
      author {
        __typename
        id
        name
        email
      }
      meal {
        __typename
        ...MealFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["MadeMeal"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("dateMade", type: .scalar(String.self)),
      GraphQLField("thoughts", type: .scalar(String.self)),
      GraphQLField("ingredientImage", type: .object(IngredientImage.selections)),
      GraphQLField("author", type: .object(Author.selections)),
      GraphQLField("meal", type: .object(Meal.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, dateMade: String? = nil, thoughts: String? = nil, ingredientImage: IngredientImage? = nil, author: Author? = nil, meal: Meal? = nil) {
    self.init(unsafeResultMap: ["__typename": "MadeMeal", "id": id, "dateMade": dateMade, "thoughts": thoughts, "ingredientImage": ingredientImage.flatMap { (value: IngredientImage) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "meal": meal.flatMap { (value: Meal) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var dateMade: String? {
    get {
      return resultMap["dateMade"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "dateMade")
    }
  }

  public var thoughts: String? {
    get {
      return resultMap["thoughts"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "thoughts")
    }
  }

  public var ingredientImage: IngredientImage? {
    get {
      return (resultMap["ingredientImage"] as? ResultMap).flatMap { IngredientImage(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "ingredientImage")
    }
  }

  public var author: Author? {
    get {
      return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "author")
    }
  }

  public var meal: Meal? {
    get {
      return (resultMap["meal"] as? ResultMap).flatMap { Meal(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "meal")
    }
  }

  public struct IngredientImage: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["CloudinaryImage_File"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicUrlTransformed", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(publicUrlTransformed: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "CloudinaryImage_File", "publicUrlTransformed": publicUrlTransformed])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var publicUrlTransformed: String? {
      get {
        return resultMap["publicUrlTransformed"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "publicUrlTransformed")
      }
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("email", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil, email: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "email": email])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var name: String? {
      get {
        return resultMap["name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var email: String? {
      get {
        return resultMap["email"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "email")
      }
    }
  }

  public struct Meal: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Meal"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MealFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var mealFragment: MealFragment {
        get {
          return MealFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct UserFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserFragment on User {
      __typename
      id
      email
      name
      permissions
      follows {
        __typename
        name
        id
      }
      followers {
        __typename
        name
        id
      }
    }
    """

  public static let possibleTypes: [String] = ["User"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("email", type: .scalar(String.self)),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("permissions", type: .scalar(UserPermissionType.self)),
      GraphQLField("follows", type: .nonNull(.list(.nonNull(.object(Follow.selections))))),
      GraphQLField("followers", type: .nonNull(.list(.nonNull(.object(Follower.selections))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, email: String? = nil, name: String? = nil, permissions: UserPermissionType? = nil, follows: [Follow], followers: [Follower]) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "email": email, "name": name, "permissions": permissions, "follows": follows.map { (value: Follow) -> ResultMap in value.resultMap }, "followers": followers.map { (value: Follower) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var permissions: UserPermissionType? {
    get {
      return resultMap["permissions"] as? UserPermissionType
    }
    set {
      resultMap.updateValue(newValue, forKey: "permissions")
    }
  }

  public var follows: [Follow] {
    get {
      return (resultMap["follows"] as! [ResultMap]).map { (value: ResultMap) -> Follow in Follow(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Follow) -> ResultMap in value.resultMap }, forKey: "follows")
    }
  }

  public var followers: [Follower] {
    get {
      return (resultMap["followers"] as! [ResultMap]).map { (value: ResultMap) -> Follower in Follower(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Follower) -> ResultMap in value.resultMap }, forKey: "followers")
    }
  }

  public struct Follow: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String? = nil, id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "name": name, "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var name: String? {
      get {
        return resultMap["name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }

  public struct Follower: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String? = nil, id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "User", "name": name, "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var name: String? {
      get {
        return resultMap["name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }
}
