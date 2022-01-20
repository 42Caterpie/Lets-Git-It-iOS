//
//  MainView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct MainView: View {
    // ObservedObject of Challenge Card View
    @ObservedObject var githubService: GithubService = GithubService()
    
    var body: some View {
        ScrollView {
            VStack {
                NameCardView()
                ChallengeCard()
                ContributionView()
                // Badge Card
            }
            .environmentObject(githubService)
        }
        .modifier(IgnoreKeyboard())
    }
}

struct IgnoreKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .ignoresSafeArea(.keyboard)
        }
        else {
            content
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
