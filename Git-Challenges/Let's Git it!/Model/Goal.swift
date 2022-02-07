//
//  Goal.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/18.
//

import Foundation

struct Goal {
    var title: String
    var count: String
    
    init(title: String = "", count: String = "365") {
        self.title = title
        self.count = count
    }
}
