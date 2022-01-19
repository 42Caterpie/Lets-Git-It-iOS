//
//  NameCardViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/18.
//

import Foundation
import Combine
import SwiftSoup
import UIKit
import SwiftUI

class NameCardViewModel: ObservableObject {
    @Published var image: UIImage = UIImage(systemName: "person.circle") ?? UIImage()
    @Published var todayCommit: Int = 0
    @ObservedObject var commitViewModel = CommitViewModel()
    
    // MARK: Subject
    //    private let nameCardSubject = PassthroughSubject<String, Never>()
    
    
    // MARK: init
    init () {
        imageCrawling()
        getTodayCommit()
    }
    
    func imageCrawling() {
        let userID = "hekang42"
        let url = URL(string: "https://github.com/\(userID)")!
        let html = try? String(contentsOf: url, encoding: .utf8)
        let doc = try? SwiftSoup.parse(html ?? "")
        let stringImage = try? doc?.select(".js-profile-editable-replace").select("img").attr("src").description
        let urlImage = URL(string: stringImage!)
        print(stringImage ?? "")
        let data = try? Data(contentsOf: urlImage!)
        self.image = UIImage(data: data!)!
    }
    
    func getTodayCommit() {
        let commits = commitViewModel.commits
        if let commits = commits {
            if commits[commits.count - 1].level == 0 {
                todayCommit = emoji.notCommitted.rawValue
            } else {
                todayCommit = emoji.committed.rawValue
            }
        }
    }
}
