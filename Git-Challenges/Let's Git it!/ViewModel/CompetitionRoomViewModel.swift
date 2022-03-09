//
//  CompetitionRoomViewModel.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/23.
//

import SwiftUI

import SwiftSoup

class CompetitionRoomViewModel: ObservableObject {
    // TODO: Users' git streak count and return the values
    
    @Published var roomData: RoomData = RoomData()
    @Published var participantStreak: [String: Int] = [:]
    @Published var ranks: [String: Int] = [:]
    var roomID: String = ""
    var host: String = ""
    
    func kickUserFromRoom(_ userNameToKick: String) {
        CompetitionService.kickUserFromRoom(
            roomID: self.roomData.id,
            userName: userNameToKick
        )
        CompetitionService.roomData(with: roomData.id) { roomData in
            self.roomData = roomData
        }
    }
    
    func calculateParticipantStreak() {
        if roomData.participants.isEmpty {
            // Error: no participants
            return
        }
        
        for participant in roomData.participants {
            let commits = getCommitData(of: participant)
            let streak = calculateStreak(with: commits)
            participantStreak[participant] = streak
            // if particiapantStreak[participant] >= goal, Alert to user
            print("\(participant): \(streak)")
        }
    }
    
    func calculatePercentage(of participant: String) -> CGFloat {
        let goal = roomData.goal
        guard let streak = participantStreak[participant]
        else {
            // Alert to user that there's no valid participant
            return 0
        }
        
        if goal == 0 || streak == 0 {
            return 0
        }
        
        return CGFloat(streak) / CGFloat(goal) < 1 ? CGFloat(streak) / CGFloat(goal) : 1
    }
    
    func maxStreak() -> Int {
        let startDate = roomData.startDate.toDate() ?? Date()
        let today = Date()
        guard let currentStreak = Calendar.current.dateComponents(
            [.day],
            from: startDate, to: today
        ).day
        else { return 0 }
        
        return currentStreak + 1
    }
    
    func isExpired() -> Bool {
        return roomData.goal < maxStreak()
    }
    
    func calculateRanking() {
        let sortedStreak = Set(participantStreak.values).sorted { $0 > $1 }
        var ranks = [String: Int]()
        var rank = 0
        var sameRankCount = 0
        
        for streak in sortedStreak {
            for (participant, participantStreak) in participantStreak {
                if streak == participantStreak {
                    ranks[participant] = rank
                    sameRankCount += 1
                }
            }
            rank += sameRankCount
            sameRankCount = 0
        }
        
        self.ranks = ranks
    }
    
    func ranking(of participant: String) -> String {
        let rankEmoji: [String] = ["🥇", "🥈", "🥉"]
        
        guard let participantRank = ranks[participant]
        else { return "" }
        
        return participantRank <= 2 ? rankEmoji[participantRank] : ""
    }
    
    private func getCommitData(of userID: String) -> [Commit] {
        var commits: [Commit] = [Commit]()
        
        let baseURL: String = "http://github.com/users/\(userID)/contributions"
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
            
            return commits
        }
        catch {
            // TODO: Alert to User
            print("Cannot Get Data: \(error.localizedDescription)")
        }
        
        return commits
    }
    
    private func calculateStreak(with commits: [Commit]) -> Int {
        let today = commits.count - 1
        let yesterday = commits.count - 2
        var streakStartDate: Date? = nil
        var streak = 0
        
        if commits.isEmpty {
            return 0
        }
        
        if commits[yesterday].level == 0 && commits[today].level == 0 {
            return 0
        }
        
        for day in stride(from: today, to: today - maxStreak(), by: -1) {
            if commits[day].level > 0 {
                streakStartDate = commits[day].date
                streak += 1
            }
            if (streakStartDate != nil && commits[day].level == 0) {
                break
            }
        }
        
        return streak
    }
    
    private func hasUserCommittedToday(_ todayCommitData: Commit?) -> Bool {
        guard let todayCommitData = todayCommitData
        else {
            return false
        }
        if todayCommitData.date.isToday && todayCommitData.level > 0 {
            return true
        }
        return false
    }
}
