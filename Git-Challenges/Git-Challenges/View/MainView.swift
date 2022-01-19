//
//  MainView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/15.
//

import SwiftUI

struct MainView: View {
    // StateObject of Challenge Card View
    @StateObject private var challengeViewModel = ChallengeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NameCardView()
                ChallengeCard(size: geometry.size)
                    .environmentObject(challengeViewModel)
                ContributionView()
                // Badge Card
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture {
                textFieldClosed()
            }
        }
    }
    
    private func textFieldClosed() {
        challengeViewModel.saveUserGoal()
        challengeViewModel.update()
        UIApplication.shared.endEditing()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
