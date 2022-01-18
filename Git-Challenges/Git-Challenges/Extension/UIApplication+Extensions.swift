//
//  UIApplication+Extensions.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/18.
//

import UIKit

// Resign First Responder Function
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
