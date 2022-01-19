//
//  Progress.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/19.
//

import SwiftUI

struct Progress: View {
    @EnvironmentObject private var challengeViewModel: ChallengeViewModel
    
    // progress field's full width
    let fullWidth: CGFloat
    
    // default padding of indicator
    let defaultPadding: CGFloat
    
    // progress bar's width and height
    let progressBarSize: CGSize
    
    // Theme Components
    private let colors: [Color] = getThemeColors()
    private let emojis: [String] = getThemeEmojis()
    
    init(fullWidth: CGFloat) {
        self.fullWidth = fullWidth
        self.defaultPadding = fullWidth * 0.08
        self.progressBarSize = CGSize(width: fullWidth * SizeRatio.progressBar.width, height: 8)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Indicator
            HStack(spacing: 0) {
                Text(emojis[emoji.committed.rawValue])
                    .modifier(IndicatorModifier(position: defaultPadding + progressBarSize.width * challengeViewModel.percentage))
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
                            color: colors[color.defaultGray.rawValue]
                        )
                    )
                Capsule()
                    .modifier(
                        ProgressBarModifier(
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

struct IndicatorModifier: ViewModifier {
    
    let position: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18))
            .padding(.bottom, 5)
            .padding(.leading, position)
    }
}

struct ProgressBarModifier: ViewModifier {
    
    let size: CGSize
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height, alignment: .leading)
            .foregroundColor(color)
    }
}
