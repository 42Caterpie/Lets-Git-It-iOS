//
//  UserInfoService.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/14.
//

import Foundation
import SwiftUI
import SwiftSoup

class UserInfoService: ObservableObject {
    @Published var commits: [Commit] = []
    @Published var currentStreak: Streak = Streak()
    @Published var userGoal: Goal = Goal()
    @Published var percentage: CGFloat = 0.0
    
    // Would be Changed after Github Login Implemented
    private let userID: String
    private let baseURL: String
    
    // Has committed Today?
    var hasCommitted: Int = emoji.notCommitted.rawValue
    
    init() {
        self.userID = UserDefaults.shared.string(forKey: "userId") ?? ""
        self.baseURL = "http://github.com/users/\(userID)/contributions"
        getUserGoal()
        getCommitData()
        calculateCurrentStreak()
        calculatePercentage(with: self.currentStreak.count)
    }
    
    func update() {
        getCommitData()
        calculateCurrentStreak()
        calculatePercentage(with: self.currentStreak.count)
    }
    
    func saveUserGoal() {
        UserDefaults.shared.set(true, forKey: "hasInitialValue")
        UserDefaults.shared.set(userGoal.title, forKey: "userGoalTitle")
        UserDefaults.shared.set(userGoal.count, forKey: "userGoalCount")
    }
    
    func calculatePercentage(with streakCount: Int) {
        if let divisor = Int(self.userGoal.count) {
            var percentage: CGFloat
            
            if divisor == 0 {
                self.percentage = 0
            }
            
            percentage = CGFloat(streakCount) / CGFloat(divisor)
            
            self.percentage = percentage <= 1 ? percentage : 1
            
            if percentage >= 1 {
                UserDefaults.shared.set(true, forKey: "finishChallengeBadge")
            }
        }
    }
    
    private func getUserGoal() {
        let title: String = UserDefaults.shared.string(forKey: "userGoalTitle") ?? ""
        let count: String = UserDefaults.shared.string(forKey: "userGoalCount") ?? "365"
        
        self.userGoal = Goal(title: title, count: count)
    }
    
    func getCommitData() {
        guard let url: URL = URL(string: baseURL) else { fatalError("Cannot Get URL") }
        if self.userID != "" {
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
                        let date = dateString.toDate() ?? Date() // 여기서 시간
                        let level = Int(levelString) ?? 0
                        
                        return Commit(date: date, level: level)
                    })
                
                if commits.last!.date.isToday && commits.last!.level > 0 {
                    self.hasCommitted = emoji.committed.rawValue
                }
            }
            catch {
                // TODO: Alert to User
                fatalError("Cannot Get Data: \(error.localizedDescription)")
            }
        }
    }
    
    func calculateCurrentStreak() {
        let yesterday: Int = commits.count - 2
        let today: Int = commits.count - 1
        var startDate: Date? = nil
        var streakCount: Int = 0
        
        if yesterday < 1 {
            currentStreak = Streak(startDate: Date().formatted, count: 0)
            return
        }
        
        if commits[yesterday].level == 0 && commits[today].level == 0 {
            currentStreak = Streak(startDate: Date().formatted, count: 0)
            return
        }
        
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
        
        currentStreak = Streak(startDate: startDate ?? Date().formatted, count: streakCount)
    }
}
