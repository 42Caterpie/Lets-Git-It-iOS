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
                // User Card
                ChallengeCard(size: geometry.size)
                // Contribution Card
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
