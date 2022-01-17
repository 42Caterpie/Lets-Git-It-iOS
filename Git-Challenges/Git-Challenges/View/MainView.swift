//
//  MainView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NameCardView()
                ChallengeCard(size: geometry.size)
                ContributionView()
                // Badge Card
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
