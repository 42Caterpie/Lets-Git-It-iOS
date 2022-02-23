//
//  CreateRoomModalView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import SwiftUI

struct CreateRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionMainViewModel: CompetitionService
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var maxParticipants: Int = 2
    @State var goal: String = "10"
    let minimumGoal: Int = 10
    
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
                    if count < minimumGoal {
                        count = minimumGoal
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
                    maxParticipants = max(2, maxParticipants - 1)
                } label: {
                    Image(systemName: "minus.circle")
                }
                Text("\(maxParticipants)")
                Button {
                    maxParticipants = min(6, maxParticipants + 1)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            HStack {
                Button {
                    let roomData: RoomData = RoomData(title: title,
                                                      startDate: startDate,
                                                      goal: goal,
                                                      maxParticipants: maxParticipants)
                    competitionMainViewModel.createRoom(with: roomData)
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

