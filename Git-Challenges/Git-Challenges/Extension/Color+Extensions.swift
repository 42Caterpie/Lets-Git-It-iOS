//
//  Color+Extensions.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/17.
//

import SwiftUI

// Color Extension to use hex color
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
