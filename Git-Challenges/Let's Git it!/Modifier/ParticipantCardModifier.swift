//
//  ParticipantCardModifier.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/03/08.
//

import SwiftUI

struct ParticipantCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(
                width: uiSize.width * widthRatio.card,
                height: 92
            )
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    .opacity(0.3)
            )
            .padding(.bottom, 15)
            .padding([.leading, .trailing], 10)
    }
}
