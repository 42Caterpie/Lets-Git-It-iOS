//
//  ChallengeViewModel.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/18.
//

import SwiftUI
import SwiftSoup

class ChallengeViewModel: ObservableObject {
    // User's Goal
    @Published var userGoal: Goal = Goal()
    
    @Published var percentage: CGFloat = 0.0
    
    init() {
        getUserGoal()
    }
    
    func calculatePercentage(with streakCount: Int) {
        let divisor = Int(self.userGoal.count) ?? 0
        var percentage: CGFloat
        
        if divisor == 0 {
            self.percentage = 0
        }
        
        percentage = CGFloat(streakCount) / CGFloat(divisor)
        
        self.percentage =  percentage <= 1 ? percentage : 1
        if percentage >= 1 {
            UserDefaults.standard.set(true, forKey: "finishChallengeBadge")
        }
    }
    
    // TODO: Save User's Goal To Server
    func saveUserGoal() {
        UserDefaults.standard.set(true, forKey: "hasInitialValue")
        UserDefaults.standard.set(userGoal.title, forKey: "userGoalTitle")
        UserDefaults.standard.set(userGoal.count, forKey: "userGoalCount")
    }
    
    // TODO: Get User's Goal From Server
    private func getUserGoal() {
        let title: String = UserDefaults.standard.string(forKey: "userGoalTitle") ?? ""
        let count: String = UserDefaults.standard.string(forKey: "userGoalCount") ?? "365"
        
        self.userGoal = Goal(title: title, count: count)
    }
}
