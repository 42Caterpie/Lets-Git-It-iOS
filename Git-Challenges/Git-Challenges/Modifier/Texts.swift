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

struct UserNameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
    }
}

struct LogoutButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
    }
}
