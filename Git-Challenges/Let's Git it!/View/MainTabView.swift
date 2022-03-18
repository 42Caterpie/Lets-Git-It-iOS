//
//  TapView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
    
    var body: some View {
        NavigationView {
            TabView {
                MainView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                CompetitionMainView()
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
                    }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}
