//
//  JoinRoomModalView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import SwiftUI

struct JoinRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionMainViewModel: CompetitionService
    @EnvironmentObject var showModalView: ShowModalView
    @State var roomNumber: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            roomNumberTextField()
            Spacer()
            joinButton()
            errorText()
        }
        .padding(.vertical)
    }
    
    private func roomNumberTextField() -> some View {
        HStack {
            Text("Room Number")
                .bold()
            Spacer()
            TextField("", text: $roomNumber)
                .keyboardType(.decimalPad)
                .frame(width: 100)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal)
    }
    
    private func joinButton() -> some View {
        Button {
            competitionMainViewModel.joinRoom(roomNumber)
            if competitionMainViewModel.isJoinable {
                showModalView.showJoinRoomModal = false
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .frame(height: 50)
                Text("Join")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
    }
    
    private func errorText() -> some View {
        Text(competitionMainViewModel.joinError)
            .foregroundColor(.red)
    }
}
