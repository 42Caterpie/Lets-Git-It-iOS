//
//  MainView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userInfoService: UserInfoService = UserInfoService()
    @ObservedObject var colorThemeService: ColorThemeService = ColorThemeService()
    
    var body: some View {
        NavigationView {
            ScrollView (showsIndicators: false) {
                VStack(spacing: 10) {
                    toolBar
                    NameCardView()
                    ChallengeCard()
                    ContributionView()
                    BadgeView()
                    Spacer()
                }
                .onAppear(perform: {
                    userCountLog()
                    colorThemeService.getThemeColors()
                    colorThemeService.getThemeEmojis()
                })
                .environmentObject(userInfoService)
                .environmentObject(colorThemeService)
                .modifier(NavigationBar())
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var toolBar: some View {
        HStack {
            Spacer()
            refreshButton
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
    
    private var refreshButton: some View {
        Button {
            userInfoService.update()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(getThemeColors()[color.defaultGray.rawValue])
                .font(.system(size: 20, weight: .bold))
        }
        .padding([.horizontal])
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
