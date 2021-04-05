//
//  GroceryListCoreDataCellView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 4/4/21.
//

import SwiftUI

struct GroceryListCoreDataCellView: View {
    var grocery: GroceryList
    @State var completeIsPressed = false
    @Environment(\.managedObjectContext) var managedObjectContext

    func toggleGroceryComplete(grocery: GroceryList) {
        grocery.isCompleted = !grocery.isCompleted

        let today = Date()

        grocery.dateCompleted = today
        try? managedObjectContext.save()

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formatter3 = iso8601DateFormatter.string(from: today)

        let mutation = CompleteGroceryListMutation(
            id: grocery.idString,
            dateCompleted: formatter3,
            isCompleted: grocery.isCompleted
        )

        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                print(error)
                managedObjectContext.undo()
            // Need to undo recent core data cahnges
            // Perhaps this takes picture or resetting contexts, then showing alert.

            case .success(let graphQLResults):
                _ = graphQLResults
            //                print("success: \(graphQLResults)")
            // Don't need to do anything as coredata as local core data already reflects
            // Perhaps this would be a good place to save the context
            }

        }
    }

    func removeItemFromGroceryList(grocery: GroceryList) {
        let mutation = DeleteGroceryListItemMutation(id: grocery.idString)

        managedObjectContext.delete(grocery)
        try? managedObjectContext.save()

        ApolloController.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                managedObjectContext.undo()
                print(error)

            case .success(let graphQLResults):
                _ = graphQLResults
            //                print("Success: \(graphQLResults)")
            }
        }
    }

    var body: some View {
        HStack {
            Button {
            } label: {
                Circle()
                    .strokeBorder(Color.black.opacity(0.6), lineWidth: 1)
                    .frame(width: 32, height: 32)
                    .foregroundColor(grocery.isCompleted ? .gray : .white)
                    .padding(.trailing, 3)
            }
            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                        .onChanged { _ in
                            completeIsPressed = true
                        }
                        .onEnded { _ in
                            // What to do when complete button is pressed
                            completeIsPressed = false
                            withAnimation {
                                toggleGroceryComplete(grocery: grocery)
                            }
                        }
            )

            VStack(alignment: .leading) {
                Text("\(grocery.groceryIngredientName) - \(grocery.groceryAmountName)")
                if grocery.isCompleted && grocery.dateCompleted != nil {
                    Text("Completed \(grocery.dateCompleted!, style: .relative) ago").font(.caption)
                } else if grocery.isCompleted {
                    Text("Completed just now").font(.caption)
                }
                if grocery.meal?.mealName != nil {
                    Text("\((grocery.meal?.mealName)!)").font(.footnote).italic()
                }
            }.foregroundColor(grocery.isCompleted ? .gray : .black)

            Spacer()
            Button {
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .gesture(TapGesture()
                        .onEnded {
                            // What happens when you tap trash button
                            withAnimation {
                                removeItemFromGroceryList(grocery: grocery)
                            }
                        }
            )
        }
    }
}

//struct GroceryListCoreDataCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroceryListCoreDataCellView()
//    }
//}
