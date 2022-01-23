//
//  Date+Extensions.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/20.
//

import Foundation

extension Date {
    var isToday: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let formattedTodayString = dateFormatter.string(from: Date())
        let formattedToday = dateFormatter.date(from: formattedTodayString)
        
        return self == formattedToday
    }
}
