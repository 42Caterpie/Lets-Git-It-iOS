//
//  Indicator.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/20.
//

import SwiftUI

struct Indicator: ViewModifier {
    
    let position: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18))
            .padding(.bottom, 5)
            .padding(.leading, position)
    }
}
