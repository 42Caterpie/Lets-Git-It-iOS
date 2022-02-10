//
//  StaticWidget.swift
//  StaticWidget
//
//  Created by 강희영 on 2022/02/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct StaticWidgetEntryView : View {
    var entry: Provider.Entry
    var userInfoService: UserInfoService = UserInfoService()
    var body: some View {
//        Text(entry.date, style: .time)
        
        VStack {
            Text(UserDefaults.shared.string(forKey: "userId") ?? "shared")
            Text("\(userInfoService.commits.count)")
            Text("userId")
        }
    }
}

@main
struct StaticWidget: Widget {
    let kind: String = "StaticWidget"
    
    init() {
        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
            UserDefaults.shared.set(value, forKey: key)
        }
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StaticWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StaticWidget_Previews: PreviewProvider {
    static var previews: some View {
        StaticWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
