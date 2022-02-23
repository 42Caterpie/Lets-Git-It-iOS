//
//  Progress.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/19.
//

import SwiftUI

struct Progress: View {
    @EnvironmentObject private var userInfoService: UserInfoService
    @EnvironmentObject private var colorThemeService: ColorThemeService
    
    // progress field's full width
    let fullWidth: CGFloat
    
    // default padding of indicator
    let defaultPadding: CGFloat
    
    // progress bar's width and height
    let progressBarSize: CGSize
    
    init() {
        self.fullWidth = uiSize.width
        self.defaultPadding = fullWidth * 0.08
        self.progressBarSize = CGSize(width: fullWidth * widthRatio.progressBar, height: 8)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // Indicator
            HStack(spacing: 0) {
                Text(colorThemeService.themeEmojis[userInfoService.hasCommitted])
                    .modifier(Indicator(position: defaultPadding + progressBarSize.width * userInfoService.percentage))
                Spacer()
            }
            
            // Progress Bar
            ZStack(alignment: .leading) {
                Capsule()
                    .modifier(
                        ProgressBarModifier(
                            size: CGSize(
                                width: progressBarSize.width,
                                height: progressBarSize.height),
                            color: colorThemeService.themeColors[color.defaultGray.rawValue]
                        )
                    )
                Capsule()
                    .modifier(
                        ProgressBarModifier(
                            size: CGSize(
                                width: progressBarSize.width * userInfoService.percentage,
                                height: progressBarSize.height),
                            color: colorThemeService.themeColors[color.progressBar.rawValue]
                        )
                    )
            }
        }
        .frame(width: fullWidth)
    }
}
