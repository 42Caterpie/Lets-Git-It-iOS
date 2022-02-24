//
//  CompetitionRoomView.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/23.
//

import SwiftUI

struct CompetitionRoomView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var competitionService: CompetitionService
    @State private var showAlert: Bool = false
    @State private var alertType: RoomModificationAlertType = .noAction
    @State private var userNameToKick: String = ""
    @State private var roomData: RoomData = RoomData()
    var roomID: String
    
    init(of roomID: String) {
        self.roomID = roomID
    }
    
    var body: some View {
        VStack {
            navigationBar
            List {
                ForEach(roomData.participants, id: \.self) { participant in
                    VStack {
                        HStack {
                            Text(participant)
                            Spacer()
                            Button {
                                alertType = .kickUserFromRoom
                                userNameToKick = participant
                                showAlert.toggle()
                            } label: {
                                Text("Kick")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        progressBar(width: uiSize.width * 0.7, height: 10, percent: 0.5)
                            .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            CompetitionService.roomData(with: roomID) { roomData in
                self.roomData = roomData
            }
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .kickUserFromRoom:
                return Alert(
                    title: Text(Message.kickUserFromRoomTitle),
                    message: Text(Message.kickUserFromRoomMessage),
                    primaryButton: .cancel(Text("Kick")) {
                        competitionService.kickUserFromRoom(
                            roomID: roomData.id,
                            userName: userNameToKick
                        )
                        CompetitionService.roomData(with: roomData.id) { roomData in
                            self.roomData = roomData
                        }
                    },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .deleteRoom:
                return Alert(
                    title: Text(Message.deleteRoomTitle),
                    message: Text(Message.deleteRoomMessage),
                    primaryButton: .cancel(Text("Delete")) {
                        competitionService.deleteRoom(roomID: roomData.id) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .default(Text("Cancel"))
                )
            case .noAction:
                break
            }
            return Alert(title: Text(""), message: Text(""), dismissButton: .cancel())
        }
    }
    
    private var navigationBar: some View {
        HStack {
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
                alertType = .deleteRoom
                showAlert.toggle()
            } label: {
                 Text("Delete")
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
}

