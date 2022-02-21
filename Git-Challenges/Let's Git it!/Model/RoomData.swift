//
//  RoomData.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import UIKit

struct RoomData: Codable {
    var title: String
    var startDate: String
    var goal: Int
    var participants: [String]
}
