//
//  RandomNumberGenarator.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import Foundation

func randomSixDigitCode() -> String {
    var number = String()
    for _ in 1...6 {
        number += "\(Int.random(in: 1...9))"
    }
    return number
}
