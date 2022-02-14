//
//  WidgetContributionView.swift
//  StaticWidgetExtension
//
//  Created by 강희영 on 2022/02/10.
//

import SwiftUI
import UIKit

struct WidgetContributionView: View {
    @EnvironmentObject var userInfoService: UserInfoService
    @EnvironmentObject var colorThemeService: ColorThemeService
    let goalTitle: String = UserDefaults.shared.string(forKey: "userGoalTitle") ?? ""
    let cols: Int = 54 - Int(uiSize.width * widthRatio.card - 20) / 16
    
    @ViewBuilder
    func ColorView(_ contributionLevel:Int) -> some View {
        let themeColors = colorThemeService.themeColors
        RoundedRectangle(cornerRadius: 2)
            .foregroundColor(themeColors[contributionLevel])
            .frame(width:13, height:13)
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .top, spacing: 3) {
                ForEach (cols..<52, id: \.self) { col in
                    VStack (spacing: 3) {
                        ForEach (0..<7, id: \.self) { row in
                            ColorView(userInfoService.commits[col * 7 + row].level)
                        }
                    }
                }
                VStack (spacing: 3) {
                    ForEach(364..<userInfoService.commits.count, id: \.self) { cell in
                        ColorView(userInfoService.commits[cell].level)
                    }
                }
            }
            .cornerRadius(4)
            HStack {
                Text(userInfoService.userGoal.title)
                Spacer()
                Text("Streaks \(userInfoService.currentStreak.count)")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(ColorPalette.green.0[0])
            .padding([.horizontal], 15)
        }
    }
}

struct WidgetContributionPreview: View {
    var colorThemeService: ColorThemeService = ColorThemeService()
    var commits: [Int] = (0..<370).map{ _ in Int.random(in: 1...4) }
    
    let goalTitle: String = "GoalTitle"
    let cols: Int = 54 - Int(uiSize.width * widthRatio.card - 20) / 16
    
    @ViewBuilder
    func ColorView(_ contributionLevel:Int) -> some View {
        let themeColors = colorThemeService.themeColors
        RoundedRectangle(cornerRadius: 2)
            .foregroundColor(themeColors[contributionLevel])
            .frame(width:13, height:13)
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .top, spacing: 3) {
                ForEach (cols..<52, id: \.self) { col in
                    VStack (spacing: 3) {
                        ForEach (0..<7, id: \.self) { row in
                            ColorView(commits[col * 7 + row])
                        }
                    }
                }
                VStack (spacing: 3) {
                    ForEach(364..<commits.count, id: \.self) { cell in
                        ColorView(commits[cell])
                    }
                }
            }
            .cornerRadius(4)
            HStack {
                Text(goalTitle)
                Spacer()
                Text("Streaks \(20)")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(ColorPalette.green.0[0])
            .padding([.horizontal], 10)
        }
    }
}

struct WidgetContributionView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetContributionView()
    }
}
