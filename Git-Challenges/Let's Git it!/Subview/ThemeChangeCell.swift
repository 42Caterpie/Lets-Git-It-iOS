//
//  ThemeChangeCell.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/10.
//

import SwiftUI

struct ThemeChangeCell: View {
    var body: some View {
        HStack {
            Text("Color Theme")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-blue")
                UserDefaults.standard.set("blue" ,forKey: "ColorTheme")
                themeLog()
            } label: {
                Image("git-challenge-icon-blue")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-green")
                UserDefaults.standard.set("green" ,forKey: "ColorTheme")
                themeLog()
            } label: {
                Image("git-challenge-icon-green")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Button {
                UIApplication.shared.setAlternateIconName("AppIcon-pink")
                UserDefaults.standard.set("pink" ,forKey: "ColorTheme")
                themeLog()
            } label: {
                Image("git-challenge-icon-pink")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .modifier(SettingCellModifier())
    }
}
