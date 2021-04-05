//
//  veggilyWidget.swift
//  veggilyWidget
//
//  Created by Travis Gerrard on 12/21/20.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    let snapshotEntry = SimpleEntry(date: Date(), mealNames: [])

    func placeholder(in context: Context) -> SimpleEntry {
        snapshotEntry
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        completion(snapshotEntry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [SimpleEntry] = []

        let managedObjectContext = DataController().container.viewContext

        let mealsToMakeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MealList")
        mealsToMakeFetch.predicate = NSPredicate(format: "isCompleted = %d", false)
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)
            
            var entry = snapshotEntry
            
            var results = [MealList]()
            var resultsNameString = [String]()
            
            do {
                results = try managedObjectContext.fetch(mealsToMakeFetch) as? [MealList] ?? []

            } catch let error as NSError { print("Could not fetch \(error), \(error.userInfo)") }
            
            results.forEach {
                resultsNameString.append($0.meal!.name!)
            }
            
            //            let randomIndex = Int(arc4random_uniform(UInt32(results.count)))

            
            entry = SimpleEntry(date: entryDate!, mealNames: resultsNameString)
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mealNames: [String]
}

struct VeggilyWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {

            ForEach(entry.mealNames, id: \.self) { entryMealList in
                Text(entryMealList).padding(.bottom, 2)

            }

        }
    }
}

@main
struct VeggilyWidget: Widget {
    let kind: String = "veggilyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            VeggilyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Veggily Widget")
        .description("See what meals are coming up.")
        .supportedFamilies([.systemMedium])
    }
}

struct VeggilyWidget_Previews: PreviewProvider {
    static var previews: some View {
        VeggilyWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                mealNames: ["Pizza", "Bean Soup", "Waffels", "Pad Thai", "Mac N Cheese"]
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
