//
//  LoginView.swift.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewmodel = LoginViewModel()
    let themeColors = getThemeColors()
    
    var body: some View {
        if !loginViewmodel.isLogin {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 211, height: 34)
                    .foregroundColor(themeColors[3])
                Text("Github 게정으로 시작하기")
            }
            .onTapGesture {
                loginViewmodel.githubLogin()
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
        } else {
            MainView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
