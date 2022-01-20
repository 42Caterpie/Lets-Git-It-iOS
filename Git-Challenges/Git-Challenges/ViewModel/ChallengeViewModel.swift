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
    
    // Current Streak Count
    @Published var currentStreak: Streak = Streak()
    
    // Percentage of Progress
    @Published var percentage: CGFloat = 0.0
    
    // Whole Commit Data
    private var commits: [Commit] = []
    
    // MARK: EnvironmentObject to ObservedObject
    @ObservedObject var githubService = GithubService()
    
    init() {
        getUserGoal()
        self.currentStreak = githubService.currentStreak
        self.percentage = calculatePercentage()
    }
    
    func update() {
        self.percentage = calculatePercentage()
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
        let count: String = UserDefaults.standard.string(forKey: "userGoalCount") ?? ""
        
        self.userGoal = Goal(title: title, count: count)
    }
    
    private func calculatePercentage() -> CGFloat {
        let divisor = Int(self.userGoal.count) ?? 0
        var percentage: CGFloat
        
        if divisor == 0 {
            return 0
        }
        
        percentage = CGFloat(self.currentStreak.count) / CGFloat(divisor)
        
        return percentage <= 1 ? percentage : 1
    }
}
