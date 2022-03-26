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
        .alert(isPresented: $notificationManager.isAlertOccurred) {
            Alert(
                title: Text(Message.notiDeniedInSettingsTitle),
                message: Text(Message.notiDeniedInSettingsMessage),
                primaryButton: .default(Text("Cancel"), action: {
                    notificationManager.isNotiOn = false
                }),
                secondaryButton: .cancel(Text("Go to Settings"), action: {
                    notificationManager.isNotiOn = false
                    openSettings()
                }))
        }
    }
    
    private func openSettings() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
}
