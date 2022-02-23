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
    @ObservedObject var competitionService = CompetitionService()
    
    var body: some View {
//        let roomDatas = competitionService.roomDatas
        NavigationView {
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
                        ForEach (competitionService.roomDatas, id: \.self.id) { room in
                            NavigationLink {
                                CompetitionRoomView(of: room.id)
                                    .environmentObject(competitionService)
                            } label: {
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
                        }
                        .buttonStyle(.plain)
                        
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
                        .environmentObject(competitionService)
                }
                .sheet(isPresented: self.$showJoinRoomModal) {
                    JoinRoomModalView()
                        .environmentObject(competitionService)
                }
            }
            .modifier(NavigationBarModifier())
        }
    }
}
