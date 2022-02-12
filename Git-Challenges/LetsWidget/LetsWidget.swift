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
        SimpleEntry(date: Date(), isPreview: false)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry: SimpleEntry
        
        if context.isPreview {
            switch context.family {
            case .systemSmall:
                entry = SimpleEntry(date: Date(), isPreview: true)
            case .systemMedium:
                entry = SimpleEntry(date: Date(), isPreview: true)
            default:
                entry = SimpleEntry(date: Date(), isPreview: true)
            }
        } else {
            entry = SimpleEntry(date: Date(), isPreview: false)
        }
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, isPreview: false)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isPreview: Bool
}

struct StaticWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry
    @ObservedObject var userInfoService: UserInfoService = UserInfoService()
    @ObservedObject var colorThemeService: ColorThemeService = ColorThemeService()
    
    var body: some View {
        if userInfoService.commits.count > 1 {
            switch widgetFamily {
            case .systemSmall:
                Text("Small")
            case .systemMedium:
                WidgetContributionView()
                    .environmentObject(userInfoService)
                    .environmentObject(colorThemeService)
            default:
                Text("unknow")
            }
        } else {
            VStack {
                Image("LoginIcon-green")
                    .resizable()
                    .frame(width: 70, height: 70)
                Text("Tap to sign in")
            }
            
        }
    }
}

struct StaticWidgetEntryPreview : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            Text("Small")
        case .systemMedium:
            WidgetContributionPreview()
        default:
            Text("unknow")
        }
    }
}

@main
struct StaticWidget: Widget {
    let kind: String = "StaticWidget"
    
    init() {
        UserDefaults.shared.dictionaryRepresentation().forEach { (key, value) in
            UserDefaults.shared.set(value, forKey: key)
        }
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Group {
                if entry.isPreview {
                    StaticWidgetEntryPreview(entry: entry)
                } else {
                    StaticWidgetEntryView(entry: entry)
                }
            }
        }
        .configurationDisplayName("Let's Git it !")
        .description("Check your commits")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//struct StaticWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        StaticWidgetEntryView(entry: SimpleEntry(date: Date()), isPreview: true)
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
