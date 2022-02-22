//
//  CompetitionViewMain.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

struct CompetitionMainView: View {
    //    var roomDatas: [RoomData] = [RoomData(title: "치킨내기", startDate: "2022-02-14", goal: 100, participants: ["hekang42"]),
    //                                 RoomData(title: "탕수육내기", startDate: "2022-02-14", goal: 200, participants: ["hekang42"])]
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
            }
        }
    }
}

struct CompetitionMainView_Previews: PreviewProvider {
    static var previews: some View {
        CompetitionMainView()
    }
}

struct CreateRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var competitionMainViewModel: CompetitionMainViewModel
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var participants: Int = 2
    
    var body: some View {
        Group {
            TextField("Set room Title", text: $title)
            HStack {
                Text("Start Date")
                DatePicker("",
                           selection: $startDate,
                           in: Date()..., displayedComponents: .date)
            }
            // MARK: GOAL Participants Mixxxxx
            
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
                    makeRoom(title, participants, startDate)
                    competitionMainViewModel.getRoomDatas()
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

struct JoinRoomModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var roomNumber: String = ""
    
    var body: some View {
        HStack {
            Text("Room Number")
            Spacer()
            TextField("", text: $roomNumber)
                .textContentType(.telephoneNumber)
                .frame(width: 100)
                .background(Color.gray)
        }
    }
}
