//
//  CompetitionViewMain.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

struct CompetitionMainView: View {
    @State private var showCreateRoomModal: Bool = false
    @State private var showJoinRoomModal: Bool = false
    @ObservedObject var competitionMainViewModel = CompetitionMainViewModel()
    
    var body: some View {
        let roomDatas = competitionMainViewModel.roomDatas
        
        VStack {
            HStack () {
                Spacer()
                Button  {
                    showJoinRoomModal = true
                } label: {
                    Text("Join")
                        .padding()
                }
            }
            ScrollView {
                VStack {
                    ForEach (roomDatas, id: \.self.id) { room in
                        VStack {
                            Text("Title: \(room.title)")
                            Text("Start Date: \(room.startDate)")
                            Text("Goal: \(room.goal)")
                            
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .padding([.trailing], -7)
                                Image(systemName: "person.circle.fill")
                                    .padding([.horizontal], -7)
                                Image(systemName: "person.circle.fill")
                                    .padding([.horizontal], -7)
                                Image(systemName: "person.circle.fill")
                                    .padding([.horizontal], -7)
                                Spacer()
                            }
                            .padding([.horizontal])
                        }
                        .modifier(CardModifier(height: 140))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(ColorPalette.green.0[1])
                                .opacity(0.8)
                        )
                        .padding([.vertical], 5)
                    }
                    
                    VStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("방 만들기")
                    }
                    .onTapGesture {
                        showCreateRoomModal = true
                    }
                    .modifier(CardModifier(height: 140))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(ColorPalette.green.0[1])
                            .opacity(0.8)
                    )
                    .padding([.vertical], 5)
                }
                Spacer()
            }
            .sheet(isPresented: self.$showCreateRoomModal) {
                CreateRoomModalView()
                    .environmentObject(competitionMainViewModel)
            }
            .sheet(isPresented: self.$showJoinRoomModal) {
                JoinRoomModalView()
                    .environmentObject(competitionMainViewModel)
            }
        }
    }
}

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
                TextField("", text: $goal)
                    .textContentType(.telephoneNumber)
                    .frame(width: 100)
                    .background(Color.gray)
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
                    competitionMainViewModel.makeRoom(title: title,
                                                      goal: Int(goal) ?? 0,
                                                      maxParticipants: participants,
                                                      startDate: startDate)
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
