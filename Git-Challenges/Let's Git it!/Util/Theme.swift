//
//  Theme.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/18.
//

import Foundation
import SwiftUI

func getThemeColors() -> [Color] {
    let colorPalette = ColorPalette()
    let themeColor: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "green"
    UserDefaults.shared.setValue(themeColor, forKey: "ColorTheme")
    return colorPalette.getColors(themeColor)
}

func getThemeEmojis() -> [String] {
    let colorPalette = ColorPalette()
    let themeColor: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "green"
    UserDefaults.shared.setValue(themeColor, forKey: "ColorTheme")
    return colorPalette.getEmoji(themeColor)
}
