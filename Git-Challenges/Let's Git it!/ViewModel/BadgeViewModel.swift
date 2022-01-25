//
//  BadgeViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import Foundation


class BadgeViewModel: ObservableObject {
    @Published var Badges: [Badge] = []
    
    init() {
        Badges = [Badge(index: 1, done: false, caption: "Taste of Victory"),
                  Badge(index: 2, done: false, caption: "Git Challenger"),
                  Badge(index: 3, done: false, caption: "Challenge Complete")]
        
        CalcBadges()
    }
    
    private func CalcBadges() {
        if UserDefaults.standard.bool(forKey: "hasInitialValue") {
            Badges[1].done = true
        }
        if UserDefaults.standard.bool(forKey: "finishChallengeBadge") {
            Badges[2].done = true
        }
    }
}
