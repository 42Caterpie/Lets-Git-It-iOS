//
//  SettingView.swift
//  Git-Challenges
//
//  Created by 권은빈 on 2022/01/20.
//

import SwiftUI
import UserNotifications
import Firebase

struct SettingView: View {
    @ObservedObject private var notificationManager: NotificationManager = NotificationManager()
    @Environment(\.loginStatus) var loging
    
    var body: some View {
        VStack {
            settings
            Spacer()
            footer
        }
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
    
    private var settings: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            Text("2unbini")
                .modifier(UserNameText())
            Divider()
            HStack {
                Text("알림 설정")
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
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
            Divider()
            Button {
                // TODO: Implement Logout Feature
                do {
                    try Auth.auth().signOut()
                    print("success log out")
                    UserDefaults.standard.removeObject(forKey: "userId")
                    self.loging.wrappedValue.toggle()
                }
                catch let signOutError as NSError {
                    print("Error signing out: ", signOutError)
                }
            } label: {
                Text("로그아웃")
                    .modifier(LogoutButtonText())
            }
            Divider()
        }
    }
    
    private var footer: some View {
        VStack {
            Text("42Caterpie")
                .font(.system(size: 14))
            Text("hekang, ekwon, bomkim")
                .font(.system(size: 12))
            Text("github.com/42Caterpie")
                .font(.system(size: 10))
        }
        .foregroundColor(getThemeColors()[color.defaultGray.rawValue])
    }
}
