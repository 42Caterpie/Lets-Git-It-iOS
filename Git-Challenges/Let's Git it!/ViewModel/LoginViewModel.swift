//
//  LoginViewModel.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/21.
//

import Foundation
import FirebaseAuth
import Alamofire
import WidgetKit

class LoginViewModel: ObservableObject {
    var provider = OAuthProvider(providerID: "github.com")
    @Published var isLogin: Bool = UserDefaults.shared.bool(forKey: "isLogin") != false
    @Published var isProgress: Bool = false
    
    func githubLogin() {
        // Request read access to a user's email addresses.
        // This must be preconfigured in the app's API permissions.
        Auth.auth().languageCode = "ko"
        provider.scopes = ["user:email"]
        provider.getCredentialWith(nil) { credential, err in
            if let err = err {
                print(err)
            }
            if let credential = credential {
                self.isProgress = true
                Auth.auth().signIn(with: credential) { authResult, err in
                    if let err = err {
                        fatalError("Login Error 2: \(err.localizedDescription)")
                    }
                    // User is signed in
                    guard let oauthCredential = authResult?.credential as? OAuthCredential else { return }
                    
                    // GitHub OAuth access token can also be retrieved by:
                    // oauthCredential.accessToken
                    // GitHub OAuth ID token can be retrieved by calling:
                    // oauthCredential.idToken
                    
                    self.getUserGithubId(oauthCredential.accessToken!) { id in
                        UserDefaults.shared.set(id, forKey: "userId")
                        
                        // MARK: Reload Widget Data
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        
                        if let authResult = authResult {
                            UserDefaults.shared.set(authResult.user.displayName, forKey: "displayName")
                        }
                        self.isProgress = false
                        self.isLogin = true
                        UserDefaults.shared.set(true, forKey: "isLogin")
                    }
                }
            }
        }
    }
    
    
    // MARK: Alamofire를 이용하여 github login accessToken으로 github login ID 구하기
    private func getUserGithubId(_ token: String, completionHandler: @escaping (String)-> Void) {
        let baseURL: URL = URL(string: "https://api.github.com/user")!
        let header: HTTPHeaders = ["Authorization" : "token " + token]
        
        Alamofire.request(baseURL, headers: header).responseJSON { response in
            switch response.result {
            case .success(let response):
                if let requestObject = response as? [String: Any] {
                    let id = requestObject["login"] as? String ?? ""
                    completionHandler(id)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func getLoginThemeImage() -> String {
        let themeColor: String = UserDefaults.shared.string(forKey: "ColorTheme") ?? "pink"
        switch themeColor {
        case "green":
            return "LoginIcon-green"
        case "blue":
            return "LoginIcon-blue"
        default :
            return "LoginIcon-pink"
        }
    }
}
