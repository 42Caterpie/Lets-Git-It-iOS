//
//  Progress.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/19.
//

import SwiftUI

struct Progress: View {
    @EnvironmentObject private var challengeViewModel: ChallengeViewModel
    @EnvironmentObject private var githubService: GithubService
    
    // progress field's full width
    let fullWidth: CGFloat
    
    // default padding of indicator
    let defaultPadding: CGFloat
    
    // progress bar's width and height
    let progressBarSize: CGSize
    
    // Theme Components
    private let colors: [Color] = getThemeColors()
    private let emojis: [String] = getThemeEmojis()
    
    init() {
        self.fullWidth = uiSize.width
        self.defaultPadding = fullWidth * 0.08
        self.progressBarSize = CGSize(width: fullWidth * widthRatio.progressBar, height: 8)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // Indicator
            HStack(spacing: 0) {
                Text(emojis[githubService.hasCommitted])
                    .modifier(Indicator(position: defaultPadding + progressBarSize.width * challengeViewModel.percentage))
                Spacer()
            }
            
            // Progress Bar
            ZStack(alignment: .leading) {
                Capsule()
                    .modifier(
                        ProgressBar(
                            size: CGSize(
                                width: progressBarSize.width,
                                height: progressBarSize.height),
                            color: colors[color.defaultGray.rawValue]
                        )
                    )
                Capsule()
                    .modifier(
                        ProgressBar(
                            size: CGSize(
                                width: progressBarSize.width * challengeViewModel.percentage,
                                height: progressBarSize.height),
                            color: colors[color.progressBar.rawValue]
                        )
                    )
            }
        }
        .frame(width: fullWidth)
    }
}
