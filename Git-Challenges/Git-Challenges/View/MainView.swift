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
        NavigationView {
            VStack(spacing: 10) {
                settings
                NameCardView()
                ChallengeCard()
                ContributionView()
                BadgeView()
                Spacer()
            }
            .environmentObject(githubService)
            .modifier(NavigationBar())
        }
    }
    
    private var settings: some View {
        HStack {
            Spacer()
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(getThemeColors()[color.defaultGray.rawValue])
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.trailing, 20)
            .padding([.top, .bottom], 10)
        }
    }
}

struct NavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .ignoresSafeArea(.keyboard)
        }
        else {
            content
                .navigationBarHidden(true)
                .navigationBarTitle("")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
