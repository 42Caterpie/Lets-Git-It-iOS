//
//  StreakProgressView.swift
//  LetsWidgetExtension
//
//  Created by 권은빈 on 2022/02/11.
//

import SwiftUI
import WidgetKit

struct StreakProgressView: View {
    @EnvironmentObject var userInfoService: UserInfoService
    
    var body: some View {
        ZStack {
            VStack {
                ProgressCircle(userInfoService.percentage, userInfoService.hasCommitted)
                StreakGoalText(streak: userInfoService.currentStreak.count)
            }
        }
    }
}

struct StreakProgressPreview: View {
    let mockData: [String: CGFloat] = ["progress": 0.3, "hasCommitted": 1, "streak": 100]
    
    var body: some View {
        ZStack {
            VStack {
                ProgressCircle(mockData["progress"]!, Int(mockData["hasCommitted"]!))
                StreakGoalText(streak: Int(mockData["streak"]!), isPreview: true)
            }
        }
    }
}

struct ProgressCircle: View {
    let progress: CGFloat
    let hasCommitted: Bool
    
    let themeColor: [Color]
    let themeEmoji: [String]
    
    init(_ progress: CGFloat, _ hasCommitted: Int) {
        self.progress = progress
        self.hasCommitted = hasCommitted == 1 ? true : false
        
        let colorPalette: ColorPalette = ColorPalette()
        let colorTheme: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "green"
        self.themeColor = colorPalette.getColors(colorTheme)
        self.themeEmoji = colorPalette.getEmoji(colorTheme)
    }
    
    var body: some View {
        ZStack {
            Text(themeEmoji[hasCommitted ? emoji.committed.rawValue : emoji.notCommitted.rawValue])
                .font(.system(size: 40))
                .padding(.top, 10)
            Circle()
                .stroke(lineWidth: 8)
                .foregroundColor(themeColor[color.defaultGray.rawValue])
                .padding(.top, 20)
                .padding(.bottom, 5)
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(themeColor[color.levelFour.rawValue])
                .rotationEffect(Angle(degrees: 270))
                .padding(.top, 20)
                .padding(.bottom, 5)
        }
    }
}

struct StreakGoalText: View {
    @State var streak: Int
    
    let goal: String = UserDefaults.shared.string(forKey: "userGoalCount") ?? "365"
    var isPreview: Bool = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("\(streak)")
                .font(.system(size: 24, weight: .bold))
            Text("/")
                .font(.system(size: 14, weight: .bold))
                .padding(.bottom, 5)
            Text(isPreview ? "365" : goal)
                .foregroundColor(ColorPalette.green.0[color.defaultGray.rawValue])
                .font(.system(size: 14, weight: .bold))
                .padding(.bottom, 3)
        }
        .padding(.bottom, 10)
    }
}

struct StreakProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StreakProgressView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
