//
//  GithubService.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/14.
//

// URL = http://github.com/users/hekang42/contributions

import Foundation
import SwiftSoup
import Combine
//import SwiftUI

class GithubService: ObservableObject {
    @Published var commits: [Commit] = []
    @Published var currentStreak: Streak = Streak()
    
    let url = URL(string: "http://github.com/users/2unbini/contributions")
    
    init() {
        getCommitData()
        currentStreak = calculateCurrentStreak()
    }
    
    func getCommitData() {
        let userID: String = "hekang42"
        let baseUrl: String = "http://github.com/users/\(userID)/contributions"
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
