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
    let progressBarSize: CGSize = CGSize(width: 290, height: 8)
    
    // Theme Components
    private let colors: [Color] = getThemeColors()
    private let emojis: [String] = getThemeEmojis()
    
    init(fullWidth: CGFloat) {
        self.fullWidth = fullWidth
        self.defaultPadding = fullWidth * 0.08
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Indicator
            HStack(spacing: 0) {
                Text(emojis[emoji.committed.rawValue])
                    .font(.system(size: 18))
                    .padding(.bottom, 5)
                    .padding(.leading, defaultPadding + progressBarSize.width * challengeViewModel.percentage)
                Spacer()
            }
            
            // Progress Bar
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: progressBarSize.width,
                           height: progressBarSize.height,
                           alignment: .leading)
                    .foregroundColor(colors[color.defaultGray.rawValue])
                
                Capsule()
                    .frame(width: progressBarSize.width * challengeViewModel.percentage,
                           height: progressBarSize.height,
                           alignment: .leading)
                    .foregroundColor(colors[color.progressBar.rawValue])
            }
        }
        .frame(width: fullWidth)
    }
}
