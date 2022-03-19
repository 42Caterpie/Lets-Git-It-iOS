//
//  NameCardViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/18.
//

import SwiftUI

import SwiftSoup

class NameCardViewModel: ObservableObject {
    @Published var image: UIImage = UIImage(systemName: "person.circle") ?? UIImage()
    
    init () {
        imageCrawling()
    }
    
    func imageCrawling() {
        let userID = UserDefaults.shared.string(forKey: "userId") ?? ""
        if userID != "" {
            let url = URL(string: "https://github.com/\(userID)")!
            let html = try? String(contentsOf: url, encoding: .utf8)
            let doc = try? SwiftSoup.parse(html ?? "")
            let stringImage = try? doc?.select(".js-profile-editable-replace")
                .select("img")
                .attr("src")
                .description
            let urlImage = URL(string: stringImage!)
            let data = try? Data(contentsOf: urlImage!)
            self.image = UIImage(data: data!)!
        }
    }
}

