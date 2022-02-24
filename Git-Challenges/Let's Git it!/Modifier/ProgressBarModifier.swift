//
//  ProgressBar.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/20.
//

import SwiftUI

struct ProgressBarModifier: ViewModifier {
    
    let size: CGSize
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height, alignment: .leading)
            .foregroundColor(color)
    }
}
