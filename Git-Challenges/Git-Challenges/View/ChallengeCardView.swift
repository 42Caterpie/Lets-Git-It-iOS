//
//  ChallengeCardView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct ChallengeCard: View {
    // EnvironmentObject of Challenge Card View
    @EnvironmentObject private var challengeViewModel: ChallengeViewModel

    // Check if the app has initial value
    @State private var hasInitialValue: Bool = UserDefaults.standard.bool(forKey: "hasInitialValue")
    
    // Size of Main View and Card View
    private let mainViewSize: CGSize
    private let cardSize: CGSize = CGSize(width: 333, height: 113)
    
    // Color Theme
    private let colors: [Color] = getThemeColors()
    
    init(size: CGSize) {
        self.mainViewSize = size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            title
            cardView
        }
    }
    
    // Title of the Challenge Card View Section
    private var title: some View {
        Text("Challenge")
            .font(.system(size: 18, weight: .bold))
    }
    
    // Card of the Challenge Card View Section
    private var cardView: some View {
        VStack(alignment: .center) {
            if hasInitialValue {
                GoalInputFields()
                Progress(fullWidth: mainViewSize.width)
            }
            else {
                cover
            }
        }
        .environmentObject(challengeViewModel)
        .frame(width: cardSize.width, height: cardSize.height)
        .modifier(CardModifier())
        .onTapGesture {
            if !hasInitialValue {
                hasInitialValue.toggle()
            }
        }
    }
    
    // Cover if there's no Initial Value
    private var cover: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .modifier(CardModifier())
                .cornerRadius(20)
            Text("😱 목표가 없어요")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(colors[color.levelOne.rawValue])
        }
    }
}
