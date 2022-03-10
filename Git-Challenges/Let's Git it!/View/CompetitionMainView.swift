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
    @State private var backgroundBlur: CGFloat = 0
    @State var sheetMode: SheetMode = .half
    @ObservedObject var keyboard: KeyboardObserver = KeyboardObserver()
    @State private var quaterModalOffset = uiSize.height / 2
    
    var body: some View {
        NavigationView {
            VStack {
                HStack () {
                    Spacer()
                    Button  {
                        showJoinRoomModal = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                ZStack {
                    ScrollView {
                        
                        HStack {
                            Text("Game List")
                                .bold()
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        VStack {
                            ForEach (competitionService.roomDatas, id: \.self.id) { room in
                                NavigationLink {
                                    CompetitionRoomView(of: room.id)
                                        .environmentObject(competitionService)
                                } label: {
                                    HStack {
                                        VStack (alignment: .leading) {
                                            Text("\(room.title)")
                                                .bold()
                                            Text("\(room.startDate) ~")
                                            //                                        Text("Goal: \(room.goal)")
                                        }
                                        Spacer()
                                    }
                                    .modifier(CardModifier(height: 144))
                                    .padding([.vertical], 5)
                                }
                            }
                            .buttonStyle(.plain)
                            //
                            //                        VStack {
                            //                            Image(systemName: "plus.circle")
                            //                                .resizable()
                            //                                .frame(width: 50, height: 50)
                            //                            Text("방 만들기")
                            //                        }
                            //                        .onTapGesture {
                            //                            showCreateRoomModal = true
                            //                        }
                            //                        .modifier(CardModifier(height: 140))
                            //                        .background(
                            //                            RoundedRectangle(cornerRadius: 20)
                            //                                .foregroundColor(ColorPalette.green.0[1])
                            //                                .opacity(0.8)
                            //                        )
                            //                        .padding([.vertical], 5)
                        }
                        Spacer()
                    }
                    
                    .disabled(showJoinRoomModal || showCreateRoomModal)
                    .blur(radius: showJoinRoomModal ? 3 : 0)
                    
                    if showJoinRoomModal {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        showJoinRoomModal = false
                                    } label: {
                                        Text("Cancle")
                                    }
                                    .padding()
                                }
                                JoinRoomModalView()
                                    .environmentObject(competitionService)
                                    .frame(height: 300)
                                Spacer()
                            }
                        }
                        .animation(.spring())
                        .offset(y: quaterModalOffset - (keyboard.isShowing ? keyboard.height : 0))
                        
                    }
                }
                //                .sheet(isPresented: self.$showCreateRoomModal) {
                //                    CreateRoomModalView()
                //                        .environmentObject(competitionService)
                //                }
                //                .sheet(isPresented: self.$showJoinRoomModal) {
                //
                //                }
                
                //                .customBottomSheet(isPresented: self.$showJoinRoomModal) {
                //                    JoinRoomModalView()
                //                        .environmentObject(competitionService)
                //                        .frame(height: 400)
                ////                        .clearModalBackground()
                //                }
                
                
            }
            .onAppear {
                self.keyboard.addObserver()
            }
            .onDisappear {
                self.keyboard.removeObserver()
            }
            .modifier(NavigationBarModifier())
        }
    }
}
