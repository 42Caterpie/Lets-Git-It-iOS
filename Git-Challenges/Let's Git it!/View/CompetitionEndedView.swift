//
//  CompetitionEndedView.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/03/11.
//

import SwiftUI

struct CompetitionEndedView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var competitionRoomViewModel: CompetitionRoomViewModel
    
    var body: some View {
        VStack {
            roomDataSection
            Divider()
            descriptionLabel
            rankList
        }
    }
    
    private var roomDataSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Start Date")
                    .bold()
                Spacer()
                Text(competitionRoomViewModel.roomData.startDate)
            }
            HStack {
                Text("End Date")
                    .bold()
                Spacer()
                Text(competitionRoomViewModel.endDate().toString)
            }
            HStack {
                Text("Goal")
                    .bold()
                Spacer()
                Text("\(competitionRoomViewModel.roomData.goal)")
                    .bold()
            }
        }
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 10)
    }
    
    private var descriptionLabel: some View {
        HStack {
            Text("Ranks")
                .font(.system(size: 23, weight: .bold))
            Spacer()
        }
        .padding(.leading, 30)
        .padding([.top, .bottom], 10)
    }
    
    private var rankList: some View {
        ScrollView {
            ForEach(competitionRoomViewModel.rankedParticipants, id: \.self) { participant in
                HStack {
                    Text("\(competitionRoomViewModel.ranking(of: participant))")
                    Text("\(participant)")
                        .bold()
                    Spacer(minLength: 0)
                    Text("\(competitionRoomViewModel.participantStreak[participant] ?? 0)")
                }
                .padding([.leading, .trailing], 30)
                .padding(.top, 10)
            }
        }
    }
}
