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
    let themeColor: String = UserDefaults.standard.string(forKey: "ColorTheme") ?? "green"
    UserDefaults.standard.setValue(themeColor, forKey: "ColorTheme")
    return colorPalette.getColors(themeColor)
}

func getThemeEmojis() -> [String] {
    let colorPalette = ColorPalette()
    let themeColor: String = UserDefaults.standard.string(forKey: "ColorTheme") ?? "green"
    UserDefaults.standard.setValue(themeColor, forKey: "ColorTheme")
    return colorPalette.getEmoji(themeColor)
}
