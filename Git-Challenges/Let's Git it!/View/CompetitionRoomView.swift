//
//  CompetitionRoomView.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/23.
//

import SwiftUI

import Firebase

struct CompetitionRoomView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var competitionService: CompetitionService
    @ObservedObject var competitionRoomViewModel: CompetitionRoomViewModel = CompetitionRoomViewModel()
    @ObservedObject var colorThemeService: ColorThemeService = ColorThemeService()
    @State private var isConfiguring: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertType: RoomModificationAlertType = .noAction
    @State private var userNameToKick: String = ""
    
    init(of roomID: String) {
        competitionRoomViewModel.roomID = roomID
    }
    
    var body: some View {
        VStack {
            navigationBar
            roomDataSection
            Divider()
            HStack {
                Text("Members")
                    .bold()
                Spacer()
            }
            .padding(.leading, 30)
            .padding([.top, .bottom], 10)
            ScrollView {
                ForEach(
                    competitionRoomViewModel.roomData.participants,
                    id: \.self
                ) { participant in
                    let percent = competitionRoomViewModel.calculatePercentage(of: participant)
                    participantView(of: participant, percent)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .overlay (
            ZStack {
                if isConfiguring {
                    Rectangle()
                        .frame(width: uiSize.width, height: uiSize.height)
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                ActivityIndicator(isAnimating: $isConfiguring, style: .medium)
            }
        )
        .onAppear {
            CompetitionService.roomData(
                with: competitionRoomViewModel.roomID, completionHandler: { roomData in
                    competitionRoomViewModel.roomData = roomData
                    competitionRoomViewModel.host = roomData.participants.first ?? ""
                    competitionRoomViewModel.calculateParticipantStreak()
                    competitionRoomViewModel.calculateRanking()
                    self.isConfiguring = false
                })
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .kickUserFromRoom:
                return Alert(
                    title: Text(Message.kickUserFromRoomTitle),
                    message: Text(Message.kickUserFromRoomMessage),
                    primaryButton: .cancel(Text("Kick")) {
                        competitionRoomViewModel.kickUserFromRoom(userNameToKick)
                    },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .deleteRoom:
                return Alert(
                    title: Text(Message.deleteRoomTitle),
                    message: Text(Message.deleteRoomMessage),
                    primaryButton: .cancel(Text("Delete")) {
                        competitionService.deleteRoom(roomID: competitionRoomViewModel.roomID) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .leaveRoom:
                return Alert(
                    title: Text(Message.leaveRoomTitle),
                    message: Text(Message.leaveRoomMessage),
                    primaryButton: .cancel(Text("Leave")) {
                        competitionService.leaveRoom(roomID: competitionRoomViewModel.roomID) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .default(Text("Cancel")))
            case .noAction:
                break
            }
            return Alert(title: Text(""), message: Text(""), dismissButton: .cancel())
        }
    }
    
    private var navigationBar: some View {
        @State var roomData = competitionRoomViewModel.roomData
        
        return HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 21))
                }
            }
            Spacer(minLength: 0)
            Text(roomData.title)
                .bold()
            Spacer(minLength: 0)
            Button {
                if isUserHost() {
                    alertType = .deleteRoom
                    showAlert.toggle()
                }
                else {
                    alertType = .leaveRoom
                    showAlert.toggle()
                }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 17))
            }
        }
        .padding()
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
                Text("Max Streak")
                    .bold()
                Spacer()
                Text("\(competitionRoomViewModel.maxStreak())")
                    .bold()
            }
        }
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 10)
        .overlay(
            ZStack {
                if competitionRoomViewModel.isExpired() {
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemBackground))
                    Text("The competition is over.")
                        .bold()
                }
            }
        )
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
            Text(participant)
                .bold()
            Text("\(competitionRoomViewModel.ranking(of: participant))")
            Spacer(minLength: 0)
            Button {
                if isUserHost() {
                    alertType = .kickUserFromRoom
                    userNameToKick = participant
                    showAlert.toggle()
                }
            } label: {
                Image(systemName: "x.circle")
                    .foregroundColor(
                        isUserHost() && !isUser(participant) ? .black : .clear
                    )
            }
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

