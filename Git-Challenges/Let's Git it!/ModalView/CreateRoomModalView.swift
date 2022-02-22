//
//  CreateRoomModalView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import SwiftUI

struct CreateRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionMainViewModel: CompetitionMainViewModel
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var participants: Int = 2
    @State var goal: String = "7"
    
    var body: some View {
        Group {
            TextField("Set room Title", text: $title)
            HStack {
                Text("Start Date")
                DatePicker("",
                           selection: $startDate,
                           in: Date()..., displayedComponents: .date)
            }
            HStack {
                Text("Goal")
                Spacer()
                TextField("365", text: $goal, onCommit: {
                    var count = Int(goal) ?? 0
                    if count < 7 {
                        count = 7
                    }
                    else if count > 365 {
                        count = 365
                    }
                    goal = String(count)
                })
                .keyboardType(.numbersAndPunctuation)
            }
            
            HStack {
                Text("Participants")
                Spacer()
                Button {
                    participants = max(2, participants - 1)
                } label: {
                    Image(systemName: "minus.circle")
                }
                Text("\(participants)")
                Button {
                    participants = min(6, participants + 1)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            HStack {
                Button {
                    competitionMainViewModel.createRoom(title: title,
                                                        goal: Int(goal) ?? 0,
                                                        maxParticipants: participants,
                                                        startDate: startDate)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
                Spacer()
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                }
            }
        }
        .padding()
    }
}

