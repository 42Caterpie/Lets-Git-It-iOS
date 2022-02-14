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
    @Environment(\.presentationMode) var presentationMode
    
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
    
    private var settings: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            userName()
            NotificationCell()
            ThemeChangeCell()
            VersionCheckCell()
            Divider()
            logoutButton()
            Divider()
        }
        .environmentObject(notificationManager)
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
        .onTapGesture {
            openGithubRepo()
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
    
    private func openGithubRepo() {
        if let url = URL(string: URLString.gitHubRepo) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func userName() -> some View {
        Text(UserDefaults.shared.string(forKey: "userId") ?? "")
            .modifier(UserNameText())
    }
    
    private func logoutButton() -> some View {
        Button {
            do {
                try Auth.auth().signOut()
                UserDefaults.shared.removeObject(forKey: "isLogin")
                UserDefaults.shared.removeObject(forKey: "userId")
                UserDefaults.shared.removeObject(forKey: "userNotiTime")
                self.notificationManager.isNotiOn = false
                self.presentationMode.wrappedValue.dismiss()
                self.loging.wrappedValue = false
            }
            catch let signOutError as NSError {
                print("Error signing out: ", signOutError)
            }
        } label: {
            Text("Log Out")
                .modifier(LogoutButtonText())
        }
    }
}
