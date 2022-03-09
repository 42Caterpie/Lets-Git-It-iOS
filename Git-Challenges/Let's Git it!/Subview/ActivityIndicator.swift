//
//  ActivityIndicator.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/21.
//
// From : https://steady-dev.tistory.com/133?category=808041
// Usage : ActivityIndicator(isAnimating: .constant(true), style: .large)

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
