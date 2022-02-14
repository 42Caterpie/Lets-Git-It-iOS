//
//  ThemeChangeCell.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/10.
//

import SwiftUI
import WidgetKit

struct ThemeChangeCell: View {
    func reloadWidget() {
        // MARK: Reload Widget Data
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    var body: some View {
        HStack {
            Text("Color Theme")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-blue")
                UserDefaults.shared.set("blue" ,forKey: "ColorTheme")
                themeLog()
                reloadWidget()
            } label: {
                Image("git-challenge-icon-blue")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-green")
                UserDefaults.shared.set("green" ,forKey: "ColorTheme")
                themeLog()
                reloadWidget()
            } label: {
                Image("git-challenge-icon-green")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-pink")
                UserDefaults.shared.set("pink" ,forKey: "ColorTheme")
                themeLog()
                reloadWidget()
            } label: {
                Image("git-challenge-icon-pink")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .modifier(SettingCellModifier())
    }
}
