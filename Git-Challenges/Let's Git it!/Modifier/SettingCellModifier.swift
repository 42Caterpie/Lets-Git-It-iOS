//
//  SettingCellModifier.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/10.
//

import SwiftUI

struct SettingCellModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
            .overlay(Divider(), alignment: .top)
    }
}
