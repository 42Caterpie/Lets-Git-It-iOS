//
//  BadgeView.swift.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import SwiftUI

struct BadgeView: View {
    @ObservedObject var badgeViewModel = BadgeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Badge")
                .font(.system(size: 18, weight: .bold))
            badgeGroup
                .modifier(CardModifier(height: 130))
        }
        .padding(.top, 15)
    }
    
    private func badgeImageCaptionView(_ badgeData: Badge) -> some View {
        let assetName: String =
        badgeData.done ?
                "badge0\(badgeData.index)-on":
                "badge0\(badgeData.index)-off"
        let caption: String = badgeData.done ? badgeData.caption : "???"
        return VStack {
            Image(assetName)
                .resizable()
                .frame(width: 77, height: 77)
            Text(caption)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
        }
    }
    
    private var badgeGroup: some View {
        let Badges: [Badge] = badgeViewModel.badges
        
        return HStack (spacing: uiSize.width / 10) {
            ForEach (Badges, id: \.self) { badge in
                badgeImageCaptionView(badge)
            }
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
