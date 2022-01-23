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
        Badges = [Badge(index: 1, done: false, caption: "승리의 맛"),
                  Badge(index: 2, done: false, caption: "깃 챌린저"),
                  Badge(index: 3, done: false, caption: "챌린지 완료")]
        
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
