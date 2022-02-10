//
//  VersionCheckCell.swift
//  Let's Git it!
//
//  Created by 권은빈 on 2022/02/10.
//

import SwiftUI

struct VersionCheckCell: View {
    var body: some View {
        HStack {
            Text("Version")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            if isAppNeedToUpdate() {
                Text("Update Needed")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .onTapGesture {
                        openAppStore()
                    }
            }
            else {
                Text("Latest Version")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
        }
        .modifier(SettingCellModifier())
    }
    
    private func isAppNeedToUpdate() -> Bool {
        guard let installedVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let url = URL(string: URLString.appStoreLookUp),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
        else { return false }
        
        if let results = json["results"] as? [[String: Any]],
           results.count > 0,
           let appstoreVersion = results[0]["version"] as? String {
            
            if installedVersion != appstoreVersion {
                return true
            }
            return false
        }
        
        return false
    }
    
    private func openAppStore() {
        if let url = URL(string: URLString.appStore) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
