//
//  NavigationBarModifier.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/23.
//

import SwiftUI

// TODO: Navigation Link로 넘어갔을 때 Back 버튼 삭제 -> custom back button

struct NavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
    }
}
