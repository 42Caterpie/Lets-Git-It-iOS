//
//  GithubService.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/14.
//

// URL = http://github.com/users/hekang42/contributions

import Foundation
import SwiftSoup
import Combine

enum HTTPError: LocalizedError {
    case statusCode
    case post
}

protocol GithubServiceable {
    func getCommits(id: String) -> AnyPublisher<[Commit]?, Never>
}

class GithubService {
    
    var commits: [Commit]? = []
    
    func getCommits(_ id: String) -> AnyPublisher<[Commit]?, Never> {
        let userID = "hekang"
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
                else { return nil}
                return Commit(date: date, level: level)
            })
        return Just(commits)
            .eraseToAnyPublisher()
    }
}


//struct GithubService: GithubServiceable {
//    private func getCommits(_ id: String) -> [Commit]? {
//        let userID = "hekang"
//        let urlAddress = "http://github.com/users/\(userID)/contributions"
//        guard let url = URL(string: urlAddress) else { return nil }
//
//        let html = try? String(contentsOf: url, encoding: .utf8)
//        let doc = try? SwiftSoup.parse(html ?? "")
//        let contributions = try? doc?.select("rect")
//        let commits = contributions?
//            .compactMap({ (element) -> (String, String)? in
//                guard let date = try? element.attr("data-date"),
//                      let level = try? element.attr("data-level") else {
//                          return nil
//                      }
//                return (date, level)
//            })
//            .compactMap({ (dateString, levelString) -> Commit? in
//                guard let level = Int(levelString),
//                      let date = dateString.toDate()
//                else { return nil}
//                return Commit(date: date, level: level)
//            })
//        return commits
//    }
//}
