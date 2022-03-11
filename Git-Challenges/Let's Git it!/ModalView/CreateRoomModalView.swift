//
//  CreateRoomModalView.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import SwiftUI

struct CreateRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionService: CompetitionService
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var maxParticipants: Int = 2
    @State var goal: String = "10"
    let minimumGoal: Int = 10
    
    var body: some View {
        VStack {
            titleTextField()
            startDatePicker()
            goalTextField()
            participantsPicker()
            makeRoomButton()
        }
        .padding()
        .font(.system(size: 18))
    }
    
    func goalTextField() -> some View {
        HStack {
            Text("Goal")
                .bold()
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
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .keyboardType(.numbersAndPunctuation)
        }
    }
    
    private func titleTextField() -> some View {
        TextField("Set room title", text: $title)
            .font(.system(size: 24, weight: .bold))
    }
    
    private func startDatePicker() -> some View {
        HStack {
            Text("Start Date")
                .bold()
            DatePicker(
                "",
                selection: $startDate,
                in: Date()..., displayedComponents: .date
            )
        }
    }
    
    private func participantsPicker() -> some View {
        ZStack {
            HStack {
                Stepper(value: $maxParticipants, in: 2...6) {
                    HStack {
                        Text("Participants")
                            .bold()
                        Spacer()
                        Text("\(maxParticipants)")
                            .padding(.trailing)
                    }
                }
            }
        }
        .padding(.bottom, 30)
    }
    
    private func makeRoomButton() -> some View {
        return Button {
            let roomData: RoomData = RoomData(
                title: title,
                startDate: startDate,
                goal: goal,
                maxParticipants: maxParticipants
            )
            competitionService.createRoom(with: roomData)
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .frame(height: 50)
                Text("Make")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
    }
}

