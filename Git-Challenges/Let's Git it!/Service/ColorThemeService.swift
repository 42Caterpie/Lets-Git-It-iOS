//
//  ColorThemeService.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/01/24.
//

import Foundation
import SwiftUI

class ColorThemeService: ObservableObject {
    private let colorPalette = ColorPalette()
    @Published var themeColors: [Color] = []
    @Published var themeEmojis: [String] = []
    
    init() {
        getThemeColors()
        getThemeEmojis()
    }
    
    func getThemeColors() {
        let themeColor: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "green"
        UserDefaults.shared.setValue(themeColor, forKey: "ColorTheme")
        self.themeColors = colorPalette.getColors(themeColor)
    }
    
    func getThemeEmojis() {
        let themeColor: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "green"
        UserDefaults.shared.setValue(themeColor, forKey: "ColorTheme")
        self.themeEmojis = colorPalette.getEmoji(themeColor)
    }
    
}
