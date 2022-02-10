//
//  NotificationSettings.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/10.
//

import SwiftUI

struct NotificationCell: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        HStack {
            Text("Notification")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            HStack {
                if notificationManager.isNotiOn {
                    DatePicker("", selection: $notificationManager.notiTime,
                               displayedComponents: .hourAndMinute)
                }
                Toggle("", isOn: $notificationManager.isNotiOn)
                    .frame(width: 60)
            }
        }
        .modifier(SettingCellModifier())
    }
}
