//
//  CompetitionInProgressView.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/03/11.
//

import SwiftUI

import Firebase

struct CompetitionInProgressView: View {
    @EnvironmentObject var competitionRoomViewModel: CompetitionRoomViewModel
    @ObservedObject var colorThemeService: ColorThemeService = ColorThemeService()
    @Binding var showAlert: Bool
    @Binding var alertType: RoomModificationAlertType
    @State private var userNameToKick: String = ""

    
    var body: some View {
        VStack {
            roomDataSection
            Divider()
            descriptionLabel
            memberList
        }
    }
    
    private var roomDataSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Start Date")
                    .bold()
                Spacer()
                Text(competitionRoomViewModel.roomData.startDate)
            }
            HStack {
                Text("Goal")
                    .bold()
                Spacer()
                Text("\(competitionRoomViewModel.roomData.goal)")
                    .bold()
            }
        }
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 10)
    }
    
    private var descriptionLabel: some View {
        HStack {
            Text("Members")
                .bold()
            Spacer()
        }
        .padding(.leading, 15)
        .padding([.top, .bottom], 10)
    }
    
    private var memberList: some View {
        ScrollView {
            ForEach(
                competitionRoomViewModel.roomData.participants,
                id: \.self
            ) { participant in
                let percent = competitionRoomViewModel.calculatePercentage(of: participant)
                participantView(of: participant, percent)
                    .onTapGesture {
                        if isUserHost() {
                            print("kick user")
                            alertType = .kickUserFromRoom
                            competitionRoomViewModel.userToKick = participant
                            showAlert.toggle()
                        }
                    }
            }
        }
    }
    
    private func participantView(of name: String, _ percent: CGFloat) -> some View {
        VStack(spacing: 10) {
            participant(name: name)
            progressBar(width: uiSize.width * widthRatio.progressBar, height: 10, percent: percent)
                .padding()
        }
        .modifier(ParticipantCardModifier())
    }
    
    private func participant(name participant: String) -> some View {
        return HStack {
            Text("\(competitionRoomViewModel.ranking(of: participant))")
            Text(participant)
                .bold()
            Spacer(minLength: 0)
            Text("\(competitionRoomViewModel.participantStreak[participant] ?? 0)")
        }
        .padding([.leading, .trailing], 20)
        .padding(.top, 15)
        .buttonStyle(PlainButtonStyle())
    }
    
    private func progressBar(width: CGFloat, height: CGFloat, percent: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width,
                            height: height
                        ),
                        color: colorThemeService.themeColors[color.defaultGray.rawValue]
                    )
                )
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width * percent,
                            height: height
                        ),
                        color: colorThemeService.themeColors[color.progressBar.rawValue]
                    )
                )
        }
    }
    
    private func isUserHost() -> Bool {
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        return userID == competitionRoomViewModel.host
    }
    
    private func isUser(_ participant: String) -> Bool {
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        return userID == participant
    }
}

