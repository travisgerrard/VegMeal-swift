//
//  MealListCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/20/21.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MealListCoreDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @AppStorage("userid") var userid = ""
    @AppStorage("isLogged") var isLogged = false
    
    static let tag: String? = "MealListView"
    
    let mealsToMake: FetchRequest<MealList>
    let mealsCompleted: FetchRequest<MealList>
    
    init() {
        mealsToMake = FetchRequest<MealList>(
            entity: MealList.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MealList.idString, ascending: false)
            ],
            predicate: NSPredicate(format: "isCompleted = %d", false))
        
        mealsCompleted = FetchRequest<MealList>(
            entity: MealList.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \MealList.dateCompleted, ascending: false)
            ],
            predicate: NSPredicate(format: "isCompleted = %d", true))
    }
    
    func loadMealList() {
        let query = GetAllMealListsForQuery(id: userid)
        ApolloController.shared.apollo.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
            
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResult):
                print("?!?! - loaded mealLists")
                if let data = graphQLResult.data {
                    if let allMealLists = data.allMealLists {
                        for mealListItem in allMealLists {
                            if let mealListFragment = mealListItem?.fragments.mealListFragment {
                                
                                
                                let mealListItemDB = MealList.object(in: managedObjectContext, withFragment: mealListFragment)
                                
                                let mealListMeal = MealDemo.object(in: managedObjectContext, withFragment: mealListFragment.meal?.fragments.mealDemoFragment)
                                
                                mealListItemDB?.meal = mealListMeal
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toggleMealComplete(mealListItem: MealList) {
        mealListItem.isCompleted = !mealListItem.isCompleted

        let today = Date()

        mealListItem.dateCompleted = today
        
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formatter3 = iso8601DateFormatter.string(from: today)
        
        let mutation = CompleteMyMealMutation(id: mealListItem.idString, dateCompleted: formatter3, isCompleted: mealListItem.isCompleted)
        try? managedObjectContext.save()

        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                managedObjectContext.undo()
                print(error)
            
            case .success(let graphQLResults):
//                print("success: \(graphQLResults)")
                _ = graphQLResults
            }
            
        }
    }
    
    func removeItemFromMealList(mealListItem: MealList) {
                let mutation = DeleteMyMealListItemMutation(id: mealListItem.idString)

        managedObjectContext.delete(mealListItem)

        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let graphQLResults):
//                print("Success: \(graphQLResults)")
                _ = graphQLResults
                try? managedObjectContext.save()

            }
        }
    }
    
    var body: some View {
        if isLogged {
            NavigationView {
                List {
                    Section(header: Text("To Make")) {
                        ForEach(mealsToMake.wrappedValue) { item in
                            HStack {
                                Button(action: {
                                }) {
                                    Circle()
                                        .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                                        .frame(width: 32, height: 32)
                                        .padding(.trailing, 3)
                                }
                                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                            .onChanged { _ in
                                            }
                                            .onEnded { _ in
                                                // Do when button is clicked
                                                withAnimation{
                                                    toggleMealComplete(mealListItem: item)
                                                }
                                                
                                            }
                                         
                                )
                                NavigationLink(
                                    destination: MealCoreDataView(meal: item.meal! /* ?? MealDemo.object(in: managedObjectContext, withFragment: MealDemoFragment(id: "123", name: "demo", description: "demo desc", mealImage: nil ,ingredientList: [], author: nil)))!*/),
                                    label: {
                                        
                                        HStack {
                                            KFImage(item.meal?.mealImageUrl,
                                                    options: [
                                                        .transition(.fade(0.2)),
                                                        .processor(
                                                            DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                                                        ),
                                                        .cacheOriginalImage
                                                    ])
                                                .placeholder {
                                                    Image("009-eggplant")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .padding(10)
                                                }
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                            Divider().background(Color.black).padding(0)
                                            VStack(alignment: .leading) {
                                                Text("\(item.mealListName)").font(.body)
                                                    .fontWeight(.bold)
                                                    .minimumScaleFactor(0.5)
                                                Text("\(item.mealListDesc)").font(.caption)
                                            }
                                        }
                                    })
                                
                                Spacer()
                                Button(action: {
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .gesture(TapGesture()
                                            .onEnded {
                                                // To do when trash button is pressed
                                                removeItemFromMealList(mealListItem: item)
                                            }
                                )
                            }
                        }
                    }
                    
                    Section(header: Text("Made")) {
                        ForEach(mealsCompleted.wrappedValue) { item in
                            HStack {
                                Button(action: {
                                }) {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 3)
                                }
                                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                            .onChanged { _ in
                                            }
                                            .onEnded { _ in
                                                // Do when button is clicked
                                                withAnimation{
                                                    toggleMealComplete(mealListItem: item)
                                                }
                                                
                                            }
                                )
                                .animation(.easeInOut)
                                NavigationLink(
                                    destination: MealCoreDataView(meal: item.meal!),
                                    label: {
                                        HStack {
                                            KFImage(item.meal?.mealImageUrl,
                                                    options: [
                                                        .transition(.fade(0.2)),
                                                        .processor(
                                                            DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                                                        ),
                                                        .cacheOriginalImage
                                                    ])
                                                .placeholder {
                                                    
                                                    Image("009-eggplant")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .padding(10)
                                                    
                                                }
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                            Divider().background(Color.black).padding(0)
                                            VStack(alignment: .leading) {
                                                Text("\(item.mealListName)").font(.body)
                                                    .fontWeight(.bold)
                                                    .minimumScaleFactor(0.5)
                                                if item.isCompleted && item.dateCompleted != nil {
                                                    Text("Completed \(item.dateCompleted!, style: .relative) ago").font(.caption)
                                                }
                                            }
                                            .foregroundColor(.gray)
                                        }
                                    })
                                
                                
                                Spacer()
                                Button(action: {
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .gesture(TapGesture()
                                            .onEnded {
                                                // Do when trash is clicked
                                                removeItemFromMealList(mealListItem: item)

                                            }
                                )
                            }
                        }
                    }
                }
                .navigationBarTitle("Meal Planner")
                
            }
            .onAppear {
//                self.loadMealList()
            }
        } else {
            LoginInCreateAccountPromt()
        }
    }
}

//struct MealListCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealListCoreDataView()
//    }
//}
