//
//  UserImage.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/03/18.
//

import SwiftUI

var savedUserProfileImage: [String: Data] = [:]

func currentUserProfileImage() -> some View {
    let userID = UserDefaults.shared.string(forKey: "userId") ?? ""
    let url = URL(string: "https://github.com/\(userID).png")!
    let data = try! Data(contentsOf: url)
    
    return Image(uiImage: UIImage(data: data)!)
        .resizable()
        .clipShape(Circle())
        .frame(width: 77, height: 77)
}


func userProfileImage(ID userID: String) -> some View {
    let imageData: Data
    
    if savedUserProfileImage[userID] != nil {
        imageData = savedUserProfileImage[userID]!
    } else {
        let url = URL(string: "https://github.com/\(userID).png?s=40")!
        
        if let data = try? Data(contentsOf: url) {
            imageData = data
            savedUserProfileImage.updateValue(imageData, forKey: userID)
        } else {
            return AnyView(Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30))
        }
    }
    return AnyView(Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 30, height: 30))
}
