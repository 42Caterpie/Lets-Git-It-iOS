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
                else { return nil}
                return Commit(date: date, level: level)
            })
    }
}
//
////MARK: MODEL
//struct PostModel: Identifiable, Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let body: String
//}
//
//class DownloadWithCombineViewModel: ObservableObject {
//
//    @Published var posts: [PostModel] = []
//    var cancellables = Set<AnyCancellable>()
//
//    init() {
//        getPosts()
//    }
//
//    func getPosts() {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .tryMap(handleOutput)
//            .decode(type: [PostModel].self, decoder: JSONDecoder())
//            .sink { completion in
//                print("Completion: \(completion)")
//            } receiveValue: { [weak self] returnedPost in
//                self?.posts = returnedPost
//            }
//            .store(in: &cancellables)
//    }
//
//    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data  {
//        guard
//            let response = output.response as? HTTPURLResponse,
//            response.statusCode >= 200 && response.statusCode < 300 else {
//                throw URLError(.badServerResponse)
//            }
//        return output.data
//
//    }
//}
//struct DownloadWithCombine: View {
//
//    @StateObject var vm = DownloadWithCombineViewModel()
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(vm.posts) { post in
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text(post.title)
//                            .font(Font.title.bold())
//                        Text(post.body)
//                            .foregroundColor(Color(UIColor.systemGray2))
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                }
//            }
//            .navigationBarTitle("Fake JSON Data")
//            .listStyle(PlainListStyle())
//        }
//    }
//}
//
//struct DownloadWithCombine_Previews: PreviewProvider {
//    static var previews: some View {
//        DownloadWithCombine()
//    }
//}
