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
    private let cardSize: CGSize
    
    // Theme Components
    private let colors: [Color] = getThemeColors()
    
    init(mainViewSize: CGSize) {
        self.cardSize = CGSize(width: mainViewSize.width * SizeRatio.challengeCard.width,
                               height: mainViewSize.height * SizeRatio.challengeCard.height)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
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
                    .modifier(SlashTextModifier(color: colors[color.defaultGray.rawValue]))
                TextField("365", text: $challengeViewModel.userGoal.count)
                    .modifier(NumberFieldModifier(color: colors[color.defaultGray.rawValue]))
            }
        }
        .frame(width: cardSize.width * 0.2)
    }
    

}

struct SlashTextModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 2)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(color)
    }
}

struct NumberFieldModifier: ViewModifier {
    
    @EnvironmentObject private var challengeViewModel: ChallengeViewModel
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onReceive(Just(challengeViewModel.$userGoal.count), perform: { _ in
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
            .foregroundColor(color)
    }
}
