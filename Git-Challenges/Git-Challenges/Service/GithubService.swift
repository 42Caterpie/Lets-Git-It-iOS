//
//  GithubService.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/14.
//

import Foundation
import SwiftSoup

class GithubService: ObservableObject {
    @Published var commits: [Commit] = []
    @Published var currentStreak: Streak = Streak()
    
    // Would be Changed after Github Login Implemented
    private let userID: String = "2unbini"
    private let baseURL: String
    
    // Has committed Today?
    var hasCommitted: Int = emoji.notCommitted.rawValue
    
    init() {
        self.baseURL = "http://github.com/users/\(userID)/contributions"
        
        getCommitData()
        currentStreak = calculateCurrentStreak()
    }
    
    func getCommitData() {
        guard let url: URL = URL(string: baseURL) else { fatalError("Cannot Get URL") }
        
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
    
    func calculateCurrentStreak() -> Streak {
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
}
