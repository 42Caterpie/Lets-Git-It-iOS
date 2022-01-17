//
//  Commit.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/15.
//

import Foundation

struct Commit: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var level: Int
    
    init(date: Date, level: Int) {
        self.date = date
        self.level = level
    }
}
