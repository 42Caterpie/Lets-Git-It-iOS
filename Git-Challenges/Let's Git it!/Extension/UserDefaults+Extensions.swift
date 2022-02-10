//
//  UserDefaults+Extensions.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/10.
//

import SwiftUI

extension UserDefaults {
    static var shared: UserDefaults {
        // ✅ App Groups Identifier 를 저장하는 변수
        // ✅ 파라미터로 전달되는 이름의 기본값으로 초기화된 UserDefaults 개체를 만든다.
        // ✅ 이전까지 사용했던 standard UserDefaults 와 다르다. 공유되는 App Group Container 에 있는 저장소를 사용한다.
        // ✅ suitename : The domain identifier of the search list.
        
//        let combined = UserDefaults.standard
        let appGroupId = "group.LetsWidget"
        return UserDefaults(suiteName: appGroupId)!
//        combined.addSuite(named: appGroupId)
//        return combined
    }
}
