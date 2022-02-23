//
//  RoomData.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import UIKit

struct RoomData: Codable {
    var id: String
    var title: String
    var startDate: String
    var goal: Int
    var participants: [String]
    var maxParticipants: Int
    
    init (title: String, startDate: Date, goal: String, maxParticipants: Int) {
        self.id = ""
        self.title = title
        self.startDate = startDate.toString
        self.goal = Int(goal) ?? 10
        self.participants = []
        self.maxParticipants = maxParticipants
    }
    
    init (id: String, title: String, startDate: String, goal: Int, participants: [String] ,maxParticipants: Int) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.goal = goal
        self.participants = participants
        self.maxParticipants = maxParticipants
    }
}
