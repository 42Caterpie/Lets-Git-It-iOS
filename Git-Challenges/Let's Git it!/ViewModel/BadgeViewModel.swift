//
//  BadgeViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import Foundation


class BadgeViewModel: ObservableObject {
    @Published var badges: [Badge] = []
    
    init() {
        initBadges()
    }
    
    private func initBadges() {
        let isSecondBadge: Bool = UserDefaults.shared.bool(forKey: "hasInitialValue")
        let isThirdBadge: Bool = UserDefaults.shared.bool(forKey: "finishChallengeBadge")
        
        badges = [Badge(index: 1, done: false, caption: "Taste of Victory"),
                  Badge(index: 2, done: isSecondBadge, caption: "Git Challenger"),
                  Badge(index: 3, done: isThirdBadge, caption: "Challenge\nComplete")]
    }
}
