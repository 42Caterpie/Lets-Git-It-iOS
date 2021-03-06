//
//  CompetitionInProgressView.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/03/11.
//

import SwiftUI

import Firebase

struct CompetitionInProgressView: View {
    @EnvironmentObject var viewModel: CompetitionRoomViewModel
    @ObservedObject var colorThemeService: ColorThemeService = ColorThemeService()
    @Binding var showAlert: Bool
    @Binding var alertType: RoomModificationAlertType
    @State private var userNameToKick: String = ""
    @State private var shouldPopupBePresented: Bool = false
    @State private var isProcessing: Bool = false

    
    var body: some View {
        ZStack {
            VStack {
                roomDataSection
                Divider()
                descriptionLabel
                memberList
            }
            
            if shouldPopupBePresented {
                footerPopup
                    .offset(x: 0, y: uiSize.height / 2 - 100)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            withAnimation(.easeInOut(duration: 2)) {
                                self.shouldPopupBePresented.toggle()
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                            self.isProcessing = false
                        }
                    }
            }
        }
    }
    
    private var roomDataSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Start Date")
                    .bold()
                Spacer()
                Text(viewModel.roomData.startDate)
            }
            HStack {
                Text("Goal")
                    .bold()
                Spacer()
                Text("\(viewModel.roomData.goal)")
                    .bold()
            }
            
            VStack {
                Button {
                    UIPasteboard.general.string = viewModel.roomID
                    if !isProcessing {
                        self.isProcessing = true
                        self.shouldPopupBePresented.toggle()
                    }
                } label: {
                        HStack {
                            Image(systemName: "square.on.square")
                            Text("\(viewModel.roomID)")
                        }
                        .font(.system(size: 14, weight: .bold))
                }
                Text("Tap to Copy")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 10)
    }
    
    private var descriptionLabel: some View {
        HStack {
            Text("Members")
                .bold()
            Spacer()
        }
        .padding(.leading, 15)
        .padding([.top, .bottom], 10)
    }
    
    private var memberList: some View {
        ScrollView {
            ForEach(
                viewModel.roomData.participants,
                id: \.self
            ) { participant in
                let percent = viewModel.calculatePercentage(of: participant)
                participantView(of: participant, percent)
                    .onTapGesture {
                        if viewModel.isUserHost() && !viewModel.isUser(participant) {
                            alertType = .kickUserFromRoom
                            viewModel.userToKick = participant
                            showAlert.toggle()
                        }
                    }
            }
        }
    }
    
    private var footerPopup: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: uiSize.width * 0.6, height: 30)
            .foregroundColor(colorThemeService.themeColors[color.defaultGray.rawValue])
            .opacity(0.7)
            .overlay(
                Text("Room ID has copied to clipboard")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
            )
    }
    
    private func participantView(of name: String, _ percent: CGFloat) -> some View {
        VStack(spacing: 10) {
            participant(name: name)
            progressBar(
                width: uiSize.width * widthRatio.progressBar,
                height: 10,
                percent: percent
            )
                .padding()
        }
        .modifier(ParticipantCardModifier())
    }
    
    private func participant(name participant: String) -> some View {
        return HStack {
            Text("\(viewModel.ranking(of: participant))")
            Text(participant)
                .bold()
            Spacer(minLength: 0)
            Text("\(viewModel.participantStreak[participant] ?? 0)")
        }
        .padding([.leading, .trailing], 20)
        .padding(.top, 15)
        .buttonStyle(PlainButtonStyle())
    }
    
    private func progressBar(width: CGFloat, height: CGFloat, percent: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width,
                            height: height
                        ),
                        color: colorThemeService.themeColors[color.defaultGray.rawValue]
                    )
                )
            Capsule()
                .modifier(
                    ProgressBarModifier(
                        size: CGSize(
                            width: width * percent,
                            height: height
                        ),
                        color: colorThemeService.themeColors[color.progressBar.rawValue]
                    )
                )
        }
    }
}

