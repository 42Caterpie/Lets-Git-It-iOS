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
    
    init() {
        getUserGoal()
        getCommitData()
        self.currentStreak = calculateCurrentStreak()
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
    
    // Get User's Commit Data
    private func getCommitData() {
        let userId: String = "hekang42"
        let baseUrl: String = "http://github.com/users/\(userId)/contributions"
        guard let url: URL = URL(string: baseUrl) else { fatalError("Cannot Get URL") }
        
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let parsedHtml = try SwiftSoup.parse(html)
            let dailyContribution = try parsedHtml.select("rect")
            
            commits = dailyContribution
                .compactMap({ element -> (String, String) in
                    guard
                        let dateString = try? element.attr("data-date"),
                        let levelString = try? element.attr("data-level")
                    else { return ("", "") }
                    
                    return (dateString, levelString)
                })
                .filter{ $0.0.isEmpty == false }
                .compactMap({ (dateString, levelString) -> Commit in
                    let date = dateString.toDate() ?? Date()
                    let level = Int(levelString) ?? 0
                    
                    return Commit(date: date, level: level)
                })
        }
        catch {
            fatalError("Cannot Get Data: \(error.localizedDescription)")
        }
    }
    
    private func calculateCurrentStreak() -> Streak {
        var startDate: Date? = nil
        var streakCount: Int = 0
        
        for day in stride(from: commits.count - 1, to: 0, by: -1) {
            if commits[day].level > 0 {
                startDate = commits[day].date
                streakCount += 1
                continue
            }
            if startDate != nil && commits[day].level == 0 {
                break
            }
        }

        return Streak(startDate: startDate ?? Date(), count: streakCount)
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
