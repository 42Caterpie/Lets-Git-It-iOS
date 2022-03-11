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
    @ObservedObject var competitionRoomViewModel: CompetitionRoomViewModel = CompetitionRoomViewModel()
    @ObservedObject var competitionService: CompetitionService = CompetitionService()
    @State private var isConfiguring: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertType: RoomModificationAlertType = .noAction

    
    init(of roomID: String) {
        competitionRoomViewModel.roomID = roomID
    }
    
    var body: some View {
        VStack {
            navigationBar
            if competitionRoomViewModel.isExpired() {
                CompetitionEndedView()
            } else {
                CompetitionInProgressView(showAlert: $showAlert, alertType: $alertType)
            }
        }
        .environmentObject(competitionRoomViewModel)
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
                        competitionRoomViewModel.kickUserFromRoom(
                            competitionRoomViewModel.userToKick
                        )
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
    
    private func isUserHost() -> Bool {
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        return userID == competitionRoomViewModel.host
    }
}
