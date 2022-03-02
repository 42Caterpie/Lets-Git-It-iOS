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
            List {
                ForEach(competitionRoomViewModel.roomData.participants, id: \.self) { participant in
                    let percent = competitionRoomViewModel.calculatePercentage(of: participant)
                    VStack {
                        HStack {
                            Text(participant)
                            Spacer()
                            Button {
                                if isUserHost() {
                                    alertType = .kickUserFromRoom
                                    userNameToKick = participant
                                    showAlert.toggle()
                                }
                            } label: {
                                Text("Kick")
                                    .foregroundColor(isUserHost() && !isUser(participant) ? .red : .clear)
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        progressBar(width: uiSize.width * 0.7, height: 10, percent: percent)
                            .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .overlay (
            ActivityIndicator(isAnimating: $isConfiguring, style: .medium)
        )
        .onAppear {
            CompetitionService.roomData(
                with: competitionRoomViewModel.roomID, completionHandler: { roomData in
                    competitionRoomViewModel.roomData = roomData
                    competitionRoomViewModel.host = roomData.participants.first ?? ""
                    competitionRoomViewModel.calculateParticipantStreak()
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
                    Text("Back")
                }
            }
            Spacer(minLength: 0)
            Text(roomData.title)
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
                Text(isUserHost() ? "Delete" : "Leave")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    private func progressBar(width: CGFloat, height: CGFloat, percent: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width,
                            height: height),
                        color: .gray
                    )
                )
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width * percent,
                            height: height),
                        color: .green
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

