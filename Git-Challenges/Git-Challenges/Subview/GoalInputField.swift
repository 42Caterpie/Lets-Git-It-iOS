//
//  GoalInputField.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/19.
//

import SwiftUI
import Combine

struct GoalInputFields: View {
    @EnvironmentObject private var challengeViewModel: ChallengeViewModel
    
    // Size Of Card
    private let cardSize: CGSize = CGSize(width: 333, height: 113)
    
    // Theme Components
    private let colors: [Color] = getThemeColors()
    private let emojis: [String] = getThemeEmojis()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            textField
            numberField
        }
    }
    
    private var textField: some View {
        TextField("Title", text: $challengeViewModel.userGoal.title, onCommit: {
            challengeViewModel.saveUserGoal()
        })
            .font(.system(size: 18, weight: .bold))
            .frame(width: cardSize.width * 0.65)
    }
    
    private var numberField: some View {
        HStack(alignment: .bottom, spacing: 0) {
            
            Text("\(Int(challengeViewModel.currentStreak.count))")
                .font(.system(size: 24, weight: .bold))
            
            HStack(alignment: .bottom, spacing: 0) {
                
                Text("/")
                    .padding(.bottom, 2)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors[color.defaultGray.rawValue])
                
                TextField("365", text: $challengeViewModel.userGoal.count)
                    .keyboardType(.numberPad)
                    .onReceive(Just(challengeViewModel.userGoal.count), perform: { _ in
                        if challengeViewModel.userGoal.count.count > 3 {
                            challengeViewModel.userGoal.count.removeLast()
                            return
                        }
                        
                        let filteredCount = challengeViewModel.userGoal.count.filter { $0.isNumber }
                        
                        if challengeViewModel.userGoal.count != filteredCount {
                            challengeViewModel.userGoal.count = filteredCount
                        }
                        
                        let number = Int(challengeViewModel.userGoal.count) ?? 0
                        if number > 365 {
                            challengeViewModel.userGoal.count = "365"
                        }
                    })
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors[color.defaultGray.rawValue])
            }
        }
        .frame(width: cardSize.width * 0.2)
    }
    
}
