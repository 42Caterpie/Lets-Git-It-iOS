//
//  CompetitionViewMain.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

struct CompetitionMainView: View {
    @State private var backgroundBlur: CGFloat = 0
    @State private var halfModalOffset = uiSize.height - 500
    @State private var showActionSheet: Bool = false
    @State private var showCreateRoomModal: Bool = false
    @State private var showJoinRoomModal: Bool = false
    @ObservedObject var keyboard: KeyboardObserver = KeyboardObserver()
    @ObservedObject var competitionService = CompetitionService()
    
    private func toolbar() -> some View {
        HStack {
            Spacer()
            Button  {
                if (!(showActionSheet || showJoinRoomModal || showCreateRoomModal)) {
                    showActionSheet = true
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
    
    private func halfModalView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.white)
                .shadow(radius: 10)
            VStack {
                if showJoinRoomModal {
                    JoinRoomModalView()
                        .environmentObject(competitionService)
                        .frame(height: 350)
                } else {
                    CreateRoomModalView()
                        .environmentObject(competitionService)
                        .frame(height: 350)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .offset(y: halfModalOffset - (keyboard.isShowing ? keyboard.height - 80 : 0))
        .animation(.spring())
    }
    
    private func competitionRoomCell(_ room: RoomData) -> some View {
        return HStack {
            VStack (alignment: .leading) {
                Text("\(room.title)")
                    .font(.system(size: 18, weight: .bold))
                Text("\(room.startDate) ~")
            }
            Spacer()
        }
        .modifier(CardModifier(height: 144))
        .padding([.vertical], 5)
    }
    
    private func gameListandModalView() -> some View {
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
                            competitionRoomCell(room)
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .disabled(showActionSheet || showJoinRoomModal || showCreateRoomModal)
            .onTapGesture {
                showActionSheet = false
                showJoinRoomModal = false
                showCreateRoomModal = false
            }
            .blur(radius: showJoinRoomModal || showActionSheet || showCreateRoomModal ? 3 : 0)
            if showJoinRoomModal || showCreateRoomModal {
                halfModalView()
            }
        }
    }
    
    private func makeJoinActionsheet() -> ActionSheet {
        return ActionSheet(
            title: Text("Select Make Room or Join Room"),
            buttons: [
                .default(
                    Text("Make Room"),
                    action: { showCreateRoomModal = true }),
                .default(Text("Join Room"), action: { showJoinRoomModal = true }),
                .cancel({ showActionSheet = false })
            ])
    }
    
    var body: some View {
        VStack {
            toolbar()
            gameListandModalView()
            .actionSheet(isPresented: $showActionSheet) {
                makeJoinActionsheet()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear {
            self.keyboard.addObserver()
        }
        .onDisappear {
            self.keyboard.removeObserver()
        }
    }
}
