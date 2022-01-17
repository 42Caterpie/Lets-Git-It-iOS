//
//  CardModifier.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/13.
//

// Add Shadow in right & bottom side
// looks like card

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    .opacity(0.3)
            )
    }
}
