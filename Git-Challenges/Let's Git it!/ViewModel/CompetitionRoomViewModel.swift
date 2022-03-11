//
//  CompetitionRoomViewModel.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/23.
//

import SwiftUI

import SwiftSoup

class CompetitionRoomViewModel: ObservableObject {
    @Published var roomData: RoomData = RoomData()
    @Published var participantStreak: [String: Int] = [:]
    @Published var ranks: [String: Int] = [:]
    @Published var rankedParticipants: [String] = [String]()
    var roomID: String = ""
    var host: String = ""
    var userToKick: String = ""
    
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
            return
        }
        
        for participant in roomData.participants {
            let commits = commitData(of: participant)
            let streak = calculateStreak(with: commits)
            participantStreak[participant] = streak
        }
    }
    
    func calculatePercentage(of participant: String) -> CGFloat {
        let goal = roomData.goal
        guard let streak = participantStreak[participant]
        else {
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
    
    func endDate() -> Date {
        let startDate = roomData.startDate.toDate() ?? Date()
        let daysAfter = roomData.goal - 1
        
        guard let endDate = Calendar.current.date(
            byAdding: DateComponents(day: daysAfter),
            to: startDate
        )
        else { return Date() }
        return endDate
    }
    
    func isExpired() -> Bool {
        return endDate() < Date()
    }
    
    func calculateRanking() {
        let sortedStreak = Set(participantStreak.values).sorted { $0 > $1 }
        var ranks = [String: Int]()
        var rankedParticipants = [String]()
        var rank = 0
        var sameRankCount = 0
        
        for streak in sortedStreak {
            for (participant, participantStreak) in participantStreak {
                if streak == participantStreak {
                    rankedParticipants.append(participant)
                    ranks[participant, default: 0] += rank
                    sameRankCount += 1
                }
            }
            rank += sameRankCount
            sameRankCount = 0
        }
        
        self.ranks = ranks
        self.rankedParticipants = rankedParticipants
    }
    
    func ranking(of participant: String) -> String {
        let rankEmoji: [String] = ["🥇", "🥈", "🥉"]
        
        guard let participantRank = ranks[participant]
        else { return "" }
        
        return participantRank <= 2 ? rankEmoji[participantRank] : ""
    }
    
    private func commitData(of userID: String) -> [Commit] {
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
                    let date = dateString.toDate() ?? Date()
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
        var today = commits.count - 1
        var yesterday = today - 1
        let endDate = self.endDate()
        var streakStartDate: Date? = nil
        var streak = 0
        
        if commits.isEmpty {
            return 0
        }
        
        while commits[today].date > endDate {
            today -= 1
        }
        yesterday = today - 1
        
        if commits[yesterday].level == 0 && commits[today].level == 0 {
            return 0
        }
        
        for day in stride(from: today, to: today - maxStreak(), by: -1) {
            if commits[day].level > 0 {
                streakStartDate = commits[day].date
                streak += 1
            }
            if roomData.startDate == commits[day].date.toString ||
                (streakStartDate != nil && commits[day].level == 0) {
                break
            }
        }
        
        return streak
    }
}
