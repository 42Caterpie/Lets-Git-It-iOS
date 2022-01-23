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
            Badges
                .modifier(CardModifier(height: 130))
        }
        .padding()
    }
    
    private var Badges : some View {
        let Badges: [Badge] = badgeViewModel.Badges
        
        return HStack (spacing: 50) {
            ForEach (Badges, id: \.self) { badge in
                let assetName: String = badge.done ? "badge0\(badge.index)-on" : "badge0\(badge.index)-off"
                let caption: String = badge.done ? badge.caption : "???"
                VStack {
                    Image(assetName)
                        .resizable()
                        .frame(width: 77, height: 77)
                    Text(caption)
                        .font(.system(size: 12))
                }
            }
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
