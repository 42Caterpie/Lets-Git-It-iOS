//
//  CompetitionViewMain.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI

class ShowModalView: ObservableObject {
    @Published var showCreateRoomModal: Bool = false
    @Published var showJoinRoomModal: Bool = false
}

struct CompetitionMainView: View {
    @State private var backgroundBlur: CGFloat = 0
    @State private var halfModalOffset = uiSize.height - 500
    @State private var showActionSheet: Bool = false
    @ObservedObject var keyboard: KeyboardObserver = KeyboardObserver()
    @ObservedObject var competitionService = CompetitionService()
    @ObservedObject var showModalView = ShowModalView()
    
    private func toolbar() -> some View {
        HStack {
            Spacer()
            Button  {
                if (!(showActionSheet ||
                      showModalView.showJoinRoomModal ||
                      showModalView.showCreateRoomModal)) {
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
                if showModalView.showJoinRoomModal {
                    JoinRoomModalView()
                        .environmentObject(competitionService)
                        .environmentObject(showModalView)
                        .frame(height: 350)
                } else {
                    CreateRoomModalView()
                        .environmentObject(competitionService)
                        .environmentObject(showModalView)
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
        return VStack (alignment: .leading) {
            Text("\(room.title)")
                .font(.system(size: 18, weight: .bold))
            Text("\(room.startDate) ~")
            HStack {
                ForEach (room.participants, id: \.self) { userID in
                    userProfileImage(ID: userID)
                        .padding(.horizontal, -10)
                }
                Spacer()
            }
            .padding(.leading, 10)
        }
        .padding(.leading, 20)
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
            .disabled(showActionSheet ||
                      showModalView.showJoinRoomModal ||
                      showModalView.showCreateRoomModal)
            .onTapGesture {
                showActionSheet = false
                showModalView.showJoinRoomModal = false
                showModalView.showCreateRoomModal = false
            }
            .blur(radius: showActionSheet ||
                  showModalView.showJoinRoomModal ||
                  showModalView.showCreateRoomModal ? 3 : 0)
            if showModalView.showJoinRoomModal || showModalView.showCreateRoomModal {
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
                    action: { showModalView.showCreateRoomModal = true }),
                .default(Text("Join Room"), action: { showModalView.showJoinRoomModal = true }),
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
            competitionService.requestRoomDatas()
            self.keyboard.addObserver()
        }
        .onDisappear {
            self.keyboard.removeObserver()
        }
    }
}
