//
//  GoalInputField.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/19.
//

import SwiftUI
import Combine

struct GoalInputFields: View {
    @EnvironmentObject private var userInfoService: UserInfoService
    
    @State private var userGoalText: String = UserDefaults.shared.string(forKey: "userGoalTitle") ?? ""
    @State private var userGoalCount: String = UserDefaults.shared.string(forKey: "userGoalCount") ?? "365"
    
    // Size Of Card
    private let cardSize: CGSize = CGSize(width: uiSize.width * widthRatio.card, height: 113)
    
    // Color Components
    private let grayColor: Color = getThemeColors()[color.defaultGray.rawValue]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            textField
            numberField
        }
    }
    
    private var textField: some View {
        TextField("Enter your Goal", text: $userGoalText, onCommit: {
            userInfoService.userGoal.title = userGoalText
            userInfoService.saveUserGoal()
            goalLog()
        })
            .font(.system(size: 18, weight: .bold))
            .frame(width: cardSize.width * 0.65)
            .padding(.leading, 20)
    }
    
    private var numberField: some View {
        HStack(alignment: .bottom, spacing: 0) {
            
            Text("\(Int(userInfoService.currentStreak.count))")
                .font(.system(size: 24, weight: .bold))
            
            HStack(alignment: .bottom, spacing: 0) {
                Text("/")
                    .modifier(SlashText(color: grayColor))
                TextField("365", text: $userGoalCount, onCommit: {
                    var count = Int(userGoalCount) ?? 0
                    
                    if count < 10 {
                        count = 10
                    }
                    else if count > 365 {
                        count = 365
                    }
                    
                    userGoalCount = String(count)
                    userInfoService.userGoal.count = String(count)
                    
                    userInfoService.saveUserGoal()
                    userInfoService.calculatePercentage(with: userInfoService.currentStreak.count)
                    goalLog()
                })
                    .modifier(NumberFieldModifier(color: grayColor, cardSize: cardSize))
            }
        }
        .frame(width: cardSize.width * 0.3)
    }
}

struct NumberFieldModifier: ViewModifier {
    
    @EnvironmentObject private var userInfoService: UserInfoService
    
    let color: Color
    let cardSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.numbersAndPunctuation)
            .onReceive(Just(userInfoService.$userGoal.count), perform: { _ in
                if userInfoService.userGoal.count.count > 3 {
                    userInfoService.userGoal.count.removeLast()
                    return
                }
                
                let filteredCount = userInfoService.userGoal.count.filter { $0.isNumber }
                
                if userInfoService.userGoal.count != filteredCount {
                    userInfoService.userGoal.count = filteredCount
                }
            })
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(color)
            .frame(width: cardSize.width * 0.1)
    }
}
