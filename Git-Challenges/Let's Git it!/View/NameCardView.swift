//
//  NameCardView.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/13.
//

import SwiftUI

struct NameCardView: View {
    @EnvironmentObject private var userInfoService: UserInfoService
    let userId = UserDefaults.shared.string(forKey: "userId") ?? ""
    let themeEmojis = getThemeEmojis()
    
    func captionText(_ caption: String) -> some View {
        Text(caption)
            .font(.system(size: 14, weight: .semibold))
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        VStack {
            userIdView
            nameCard
        }
        .modifier(CardModifier(height: 140))
    }
    
    private var userIdView: some View {
        HStack {
            Text(userId)
                .font(.system(size: 18, weight: .bold))
                .padding([.horizontal])
            Spacer()
        }
    }
    
    private var nameCard: some View {
        HStack {
            Spacer()
            currentUserProfileImage()
            Spacer()
            Spacer()
            VStack (spacing: 0) {
                Text("\(userInfoService.currentStreak.count)")
                    .font(.system(size: 36, weight: .bold))
                captionText("days\nongoing")
                    .scaledToFill()
            }
            Spacer()
            Spacer()
            VStack (spacing: 0) {
                Text(themeEmojis[userInfoService.hasCommitted])
                    .font(.system(size: 36, weight: .bold))
                captionText("today\ncommit")
                    .scaledToFill()
            }
            Spacer()
        }
        .padding([.horizontal])
    }
}

struct NameCardView_Previews: PreviewProvider {
    static var previews: some View {
        NameCardView()
    }
}
