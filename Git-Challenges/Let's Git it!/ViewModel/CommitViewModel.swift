//
//  CommitViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/15.
//

import Foundation
import Combine
import SwiftUI
import SwiftSoup

class CommitViewModel: ObservableObject {
    @Published var commits: [Commit]? = []
    
    let url = URL(string: "http://github.com/users/2unbini/contributions")
    
    init() {
        getCommits()
    }
    
    func getCommits() {
        let userID = "hekang42"
        let urlAddress = "http://github.com/users/\(userID)/contributions"
        let url = URL(string: urlAddress)!
        
        let html = try? String(contentsOf: url, encoding: .utf8)
        let doc = try? SwiftSoup.parse(html ?? "")
        let contributions = try? doc?.select("rect")
        
        self.commits = contributions?
            .compactMap({ (element) -> (String, String)? in
                guard let date = try? element.attr("data-date"),
                      let level = try? element.attr("data-level") else {
                          return nil
                      }
                return (date, level)
            })
            .compactMap({ (dateString, levelString) -> Commit? in
                guard let level = Int(levelString),
                      let date = dateString.toDate()
                else { return nil }
                return Commit(date: date, level: level)
            })
    }
}
