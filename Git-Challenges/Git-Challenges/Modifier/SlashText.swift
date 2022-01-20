//
//  TextModifiers.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/20.
//

import SwiftUI

struct SlashText: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 2)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(color)
    }
}
