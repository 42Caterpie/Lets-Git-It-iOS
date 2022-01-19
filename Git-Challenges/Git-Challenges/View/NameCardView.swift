//
//  NameCardView.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/13.
//

import SwiftUI

struct NameCardView: View {
    @State var daysOngoing: Int = 10
    @StateObject var nameCardViewModel = NameCardViewModel()
    let themeEmojis = getThemeEmojis()
    
    func captionText(_ caption: String) -> some View {
        Text(caption)
            .font(.system(size: 14, weight: .semibold))
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("hekang")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            HStack {
                Image(uiImage: nameCardViewModel.image)
                    .resizable()
                    .frame(width: 77, height: 77)
                Spacer()
                VStack {
                    Text("\(daysOngoing)")
                        .font(.system(size: 36, weight: .bold))
                        .padding([.bottom], 4)
                    captionText("days\nongoing")
                }
                Spacer()
                VStack {
                    Text(themeEmojis[nameCardViewModel.todayCommit])
//                    Text("❄️")
                        .font(.system(size: 36, weight: .bold))
                        .padding([.bottom], 4)
                    captionText("today\ncommit")
                }
                Spacer()
            }
            .frame(alignment:.center)
        }
        .frame(width:333 , height:140)
        .padding()
        .modifier(CardModifier())
    }
}

struct NameCardView_Previews: PreviewProvider {
    static var previews: some View {
        NameCardView()
    }
}
