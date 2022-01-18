//
//  Streak.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/18.
//

import Foundation

struct Streak {
    let startDate: Date
    var count: Int
    
    init(startDate: Date = Date(), count: Int = 0) {
        self.startDate = startDate
        self.count = count
    }
}
