//
//  JoinRoomModalView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import SwiftUI

struct JoinRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionMainViewModel: CompetitionMainViewModel
    @State var roomNumber: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Room Number")
                Spacer()
                TextField("", text: $roomNumber)
                    .textContentType(.telephoneNumber)
                    .frame(width: 100)
                    .background(Color.gray)
            }
            Button {
                competitionMainViewModel.joinRoom(roomNumber)
                if competitionMainViewModel.isJoinable {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Join")
            }
            Text(competitionMainViewModel.joinError)
                .foregroundColor(.red)
        }
    }
}
