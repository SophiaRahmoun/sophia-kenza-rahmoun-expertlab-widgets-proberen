//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by admin on 24/11/2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DayEntry {
        DayEntry(date: Date())
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<DayEntry> {
        var entries: [DayEntry] = []
        let currentDate = Date()

        for dayOffset in 0..<7 {
            let entryDate = Calendar.current.date(
                byAdding: .day,
                value: dayOffset,
                to: currentDate
            )!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            
            entries.append(DayEntry(date: entryDate))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}
struct MonthlyWidgetEntryView: View {
    var entry: DayEntry
    var config: MonthConfig
  
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }

    var body: some View {
        ZStack {
            Color.gray
                .overlay(config.backgroundColor.gradient)

            VStack(alignment: .leading, spacing: 6) {

                HStack(spacing: 4) {
                    Spacer()
                    Text(config.emojiText)
                        .font(.title)
                    
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .bold()
                        .foregroundColor(config.weekdayTextColor)
                        .minimumScaleFactor(0.5)

                    Spacer()
                }

                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                    .padding(.leading)
            }
        }
     
        .containerBackground(for: .widget) {
            Color.clear
              
        }
    }
}


struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Widget")
        .description("Shows your date.")
        .contentMarginsDisabled()
        .description("The theme of the widget changes based on month.")
        .supportedFamilies([.systemSmall]) // support only small size

    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DayEntry(date: .now)
        //    DayEntry(date: previewDate(month: 3, day: 30)) to test days & months 

    DayEntry(date: .now.addingTimeInterval(3600))
}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
    
}
