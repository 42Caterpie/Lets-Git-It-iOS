//
//  CompetitionViewMain.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/14.
//

import SwiftUI


struct CompetitionMainView: View {
    var roomDatas: [RoomData] = [RoomData(id: 1, title: "치킨내기", startDate: "2022-02-14", goal: 100),
                                 RoomData(id: 2, title: "탕수육내기", startDate: "2022-02-14", goal: 200)]
    @State private var showModal: Bool = false
    
    
    var body: some View {
        VStack {
            HStack () {
                Spacer()
                Text("참석")
                    .padding()
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
                        showModal = true
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
            .sheet(isPresented: self.$showModal) {
                CreateRoomModalView()
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
    @State var title: String = ""
    
    var body: some View {
        Group {
            TextField("Set room Title", text: $title)
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Dismiss")
            }

        }
    }
}
