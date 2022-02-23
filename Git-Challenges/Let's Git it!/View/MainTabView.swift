//
//  TapView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Menu")
                }
            
            CompetitionMainView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Menu")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
