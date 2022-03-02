//
//  Constants.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/16.
//

import Foundation
import SwiftUI

let uiSize: CGSize = UIScreen.main.bounds.size

enum URLString {
    static let gitHubRepo: String = "https://github.com/42Caterpie/Lets-Git-It-iOS"
    static let appStore: String = "itms-apps://itunes.apple.com/app/1606646308"
    static let appStoreLookUp: String = "https://itunes.apple.com/lookup?bundleId=com.github.Caterpie"
}

enum Message {
    static let notiDeniedInSettingsTitle: String = "Notification has been disabled for this app"
    static let notiDeniedInSettingsMessage: String = "Please go to settings to enable it now"
    static let kickUserFromRoomTitle: String = "Kick the user out of this room"
    static let kickUserFromRoomMessage: String = "This cannot be restored.\nReally want to kick the user?"
    static let deleteRoomTitle: String = "Delete this room"
    static let deleteRoomMessage: String = "This cannot be restored.\nReally want to delete the room?"
    static let leaveRoomTitle: String = "Leave this room"
    static let leaveRoomMessage: String = "This cannot be restored.\nReally want to leave the room?"
}

enum JoinErrorMessage {
    static let roomIsFull = "Room is full."
    static let alreadyInRoom = "Already in The Room."
    static let cantFindRoom = "Room doesn't exist."
    static let noRoomID = "Please enter your room number."
    static let kickedID = "Cannot access the room."
}

enum RoomModificationAlertType {
    case kickUserFromRoom
    case deleteRoom
    case noAction
    case leaveRoom
}

enum widthRatio {
    static let card: CGFloat = 0.888
    static let badge: CGFloat = 1
    static let progressBar: CGFloat = 0.773
}

enum color: Int {
    case defaultGray = 0
    case levelOne
    case levelTwo
    case levelThree
    case levelFour
    case progressBar
}

enum emoji: Int {
    case notCommitted = 0
    case committed
}

struct ColorPalette {
    static var pink: ([Color], [String]) = (
        [
            Color(hex: 0xC4C4C4),
            Color(hex: 0xF0C1C1),
            Color(hex: 0xFBAAAA),
            Color(hex: 0xF09696),
            Color(hex: 0xE78181),
            Color(hex: 0xE68181)
        ],
        [
            "😡",
            "🔥"
        ]
    )
    
    static var blue: ([Color], [String]) = (
        [
            Color(hex: 0xC4C4C4),
            Color(hex: 0xC1DAF0),
            Color(hex: 0xA0C7EA),
            Color(hex: 0x86ADD0),
            Color(hex: 0x6DA8DB),
            Color(hex: 0x6DA8DB),
        ],
        [
            "❄️",
            "🌊"
        ]
    )
    
    static var green: ([Color], [String]) = (
        [
            Color(hex: 0xC4C4C4),
            Color(hex: 0xCAEBBB),
            Color(hex: 0xAFDB9B),
            Color(hex: 0x9BC987),
            Color(hex: 0x85C767),
            Color(hex: 0x85C767),
        ],
        [
            "🍃",
            "🌿"
        ]
    )
    
    func getColors(_ color: String) -> [Color] {
        switch color {
        case "pink":
            return ColorPalette.pink.0
        case "blue":
            return ColorPalette.blue.0
        case "green":
            return ColorPalette.green.0
        default:
            return []
        }
    }
    
    func getEmoji(_ color: String) -> [String] {
        switch color {
        case "pink":
            return ColorPalette.pink.1
        case "blue":
            return ColorPalette.blue.1
        case "green":
            return ColorPalette.green.1
        default:
            return []
        }
    }
}
