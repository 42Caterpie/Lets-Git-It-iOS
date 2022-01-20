//
//  ChallengeCardView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct ChallengeCard: View {
    // ObservedObject of Challenge Card View
    @ObservedObject var challengeViewModel = ChallengeViewModel()
    
    // Check if the app has initial value
    @State private var hasInitialValue: Bool = UserDefaults.standard.bool(forKey: "hasInitialValue")
    
    // Color Theme
    private let colors: [Color] = getThemeColors()
    
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
                Group {
                    GoalInputFields()
                    Progress()
                }
                .environmentObject(challengeViewModel)
            }
            else {
                cover
            }
        }
        .modifier(CardModifier(height: 113))
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
                .modifier(CardModifier(height: 113))
                .cornerRadius(20)
            Text("😱 목표가 없어요")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(colors[color.levelOne.rawValue])
        }
    }
}
