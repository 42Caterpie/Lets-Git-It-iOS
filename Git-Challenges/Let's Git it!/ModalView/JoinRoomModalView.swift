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
    @State var roomNumber: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Room Number")
                    .bold()
                Spacer()
                TextField("", text: $roomNumber)
                    .textContentType(.telephoneNumber)
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            Spacer()
            Button {
                competitionMainViewModel.joinRoom(roomNumber)
                if competitionMainViewModel.isJoinable {
                    self.presentationMode.wrappedValue.dismiss()
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
            Text(competitionMainViewModel.joinError)
                .foregroundColor(.red)
        }
        .padding(.vertical)
//        .frame(height: 300)
    }
}
