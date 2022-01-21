//
//  LoginView.swift.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    var provider = OAuthProvider(providerID: "github.com")
    @State var islogin: Bool = false
    
    var body: some View {
        if !islogin {
            Button("Github Login") {
                githubLogin()
            }
        } else {
            MainView()
        }
    }
    
    private func githubLogin() {
        // Request read access to a user's email addresses.
        // This must be preconfigured in the app's API permissions.
        provider.scopes = ["user:email"]
        provider.getCredentialWith(nil) { credential, err in
            if let err = err {
                print(err)
            }
            if let credential = credential {
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
                    
                    print(authResult?.user.displayName ?? "")
                    print(oauthCredential)
                    islogin = true
                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
