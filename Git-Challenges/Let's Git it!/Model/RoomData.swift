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
}
