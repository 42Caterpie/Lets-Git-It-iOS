//
//  Constants.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/16.
//

import Foundation
import SwiftUI

// Usage:
// UserDefault에 theme을 key로 하는 객체 저장
// UserDefault.standard.set(ColorPalette.pink, forKey: "theme")
// let theme = UserDefault.standard.object("theme")

struct ColorPalette {
    
    static var pink: ([String: Color], [String: String]) = (
        [
            "progressBar": Color(hex: 0xE68181),
            "levelOne": Color(hex: 0xF0C1C1),
            "levelTwo": Color(hex: 0xFBAAAA),
            "levelThree": Color(hex: 0xE78181),
            "defaultGray": Color(hex: 0xC4C4C4)
        ],
        [
            "notComitted": "😡",
            "committed": "🔥"
            
        ]
    )
    
    static var blue: ([String: Color], [String: String]) = (
        [
            "progressBar": Color(hex: 0x6DA8DB),
            "levelOne": Color(hex: 0xC1DAF0),
            "levelTwo": Color(hex: 0xA0C7EA),
            "levelThree": Color(hex: 0x6DA8DB),
            "defaultGray": Color(hex: 0xC4C4C4)
        ],
        [
            "notComitted": "❄️",
            "committed": "🌊"
            
        ]
    )
    
    static var green: ([String: Color], [String: String]) = (
        [
            "progressBar": Color(hex: 0x85C767),
            "levelOne": Color(hex: 0xCAEBBB),
            "levelTwo": Color(hex: 0xAFDB9B),
            "levelThree": Color(hex: 0x85C767),
            "defaultGray": Color(hex: 0xC4C4C4)
        ],
        [
            "notComitted": "🍃",
            "committed": "🌿"
            
        ]
    )
}
