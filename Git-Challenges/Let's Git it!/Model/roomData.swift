//
//  RoomData.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import UIKit

struct RoomData: Codable, Equatable {
    var id: String
    var title: String
    var startDate: String
    var goal: Int
    var participants: [String]
    var kickedUsers: [String]
    var maxParticipants: Int
    
    init() {
        self.id = ""
        self.title = ""
        self.startDate = ""
        self.goal = 0
        self.participants = [String]()
        self.kickedUsers = [String]()
        self.maxParticipants = 0
    }
    
    init (title: String, startDate: Date, goal: String, maxParticipants: Int) {
        self.id = ""
        self.title = title
        self.startDate = startDate.toString
        self.goal = Int(goal) ?? 10
        self.participants = [String]()
        self.kickedUsers = [String]()
        self.maxParticipants = maxParticipants
    }
    
    init (id: String, title: String, startDate: String, goal: Int, participants: [String] ,maxParticipants: Int) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.goal = goal
        self.participants = participants
        self.kickedUsers = [String]()
        self.maxParticipants = maxParticipants
    }
}
