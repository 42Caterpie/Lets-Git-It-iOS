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
            Text(UserDefaults.standard.string(forKey: "userId")!)
                .modifier(UserNameText())
            Divider()
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
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
            Divider()
            HStack {
                Text("Color Theme")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button {
                    UIApplication.shared.setAlternateIconName("AppIcon-blue")
                    UserDefaults.standard.set("blue" ,forKey: "ColorTheme")
                    ThemeLog()
                } label: {
                    Image("git-challenge-icon-blue")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Button {
                    UIApplication.shared.setAlternateIconName("AppIcon-green")
                    UserDefaults.standard.set("green" ,forKey: "ColorTheme")
                    ThemeLog()
                } label: {
                    Image("git-challenge-icon-green")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Button {
                    UIApplication.shared.setAlternateIconName("AppIcon-pink")
                    UserDefaults.standard.set("pink" ,forKey: "ColorTheme")
                    ThemeLog() 
                } label: {
                    Image("git-challenge-icon-pink")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            .padding([.leading, .trailing], 20)
            .frame(height: 64)
            
            
            Divider()
            
            Button {
                // TODO: Implement Logout Feature
                do {
                    try Auth.auth().signOut()
                    UserDefaults.standard.removeObject(forKey: "autoLogin")
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
