//
//  ContributionView.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/14.
//

import SwiftUI
import UIKit

struct ContributionView: View {
    @EnvironmentObject private var userInfoService: UserInfoService
    @EnvironmentObject var colorThemeService: ColorThemeService
    let weekday = Calendar.current.component(.weekday, from: Date())
    
    @ViewBuilder
    func ColorView(_ contributionLevel:Int) -> some View {
        let themeColors = colorThemeService.themeColors
        RoundedRectangle(cornerRadius: 2)
            .foregroundColor(themeColors[contributionLevel])
            .frame(width:15, height:15)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Contribution")
                .font(.system(size: 18, weight: .bold))
            ZStack {
                HStack(){}
                .modifier(CardModifier(height: 150))
                ScrollView (.horizontal) {
                    HStack (spacing: 3) {
                        ForEach (35..<52, id: \.self) { col in
                            VStack (spacing: 3) {
                                ForEach (0..<7, id: \.self) { row in
                                    ColorView(userInfoService.commits[col * 7 + row].level)
                                }
                            }
                        }
                        VStack (spacing: 3) {
                            ForEach(364..<userInfoService.commits.count, id: \.self) { cell in
                                ColorView(userInfoService.commits[cell].level)
                            }
                            Spacer()
                        }
                    }
                    .cornerRadius(4)
                    .padding()
                }
                .frame(width:353, height: 100)
            }
        }
    }
}

struct ContributionView_Previews: PreviewProvider {
    static var previews: some View {
        ContributionView()
    }
}
