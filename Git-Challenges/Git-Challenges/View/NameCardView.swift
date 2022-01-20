//
//  NameCardView.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/13.
//

import SwiftUI

struct NameCardView: View {
    @ObservedObject var nameCardViewModel = NameCardViewModel()
    
    let themeEmojis = getThemeEmojis()
    
    func captionText(_ caption: String) -> some View {
        Text(caption)
            .font(.system(size: 14, weight: .semibold))
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        VStack {
            userIdView
            nameCard
        }
        .frame(width:333 , height:140)
        .padding()
        .modifier(CardModifier())
    }
    
    private var userIdView: some View {
        HStack {
            Text("hekang")
                .font(.system(size: 18, weight: .bold))
            Spacer()
        }
    }
    
    private var nameCard: some View {
        HStack {
            Image(uiImage: nameCardViewModel.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 77, height: 77)
            Spacer()
            VStack {
                Text("\(nameCardViewModel.currentStreak)")
                    .font(.system(size: 36, weight: .bold))
                    .padding([.bottom], 4)
                captionText("days\nongoing")
                    .scaledToFill()
            }
            Spacer()
            VStack {
                Text(themeEmojis[nameCardViewModel.todayCommit])
                    .font(.system(size: 36, weight: .bold))
                    .padding([.bottom], 4)
                captionText("today\ncommit")
            }
            Spacer()
        }
    }
}

struct NameCardView_Previews: PreviewProvider {
    static var previews: some View {
        NameCardView()
    }
}
