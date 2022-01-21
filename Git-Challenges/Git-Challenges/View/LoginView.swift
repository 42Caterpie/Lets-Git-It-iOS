//
//  LoginView.swift.swift
//  Git-Challenges
//
//  Created by 강희영 on 2022/01/20.
//

import SwiftUI

struct LoginStatusKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var loginStatus : Binding<Bool> {
        get { self[LoginStatusKey.self] }
        set { self[LoginStatusKey.self] = newValue }
    }
}

struct LoginView: View {
    @ObservedObject var loginViewmodel = LoginViewModel()
    let themeColors = getThemeColors()
    
    var body: some View {
        @State var autoLogin: Bool = UserDefaults.standard.bool(forKey: "autoLogin") != false
        
        return Group {
            if loginViewmodel.isLogin == false && autoLogin == false {
                VStack (alignment: .center) {
                    Image("LoginIcon")
                    HStack(spacing: 3) {
                        Text("Let's")
                        Text("Git")
                            .fontWeight(.bold)
                        Text("it!")
                    }
                    .font(.system(size: 12))
                    .padding([.top], -20)
                    .padding([.bottom], 20)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 211, height: 34)
                            .foregroundColor(themeColors[4])
                        Text("Github 게정으로 시작하기")
                    }
                    .onTapGesture {
                        loginViewmodel.githubLogin()
                        UserDefaults.standard.set(true, forKey: "autoLogin")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                }
            } else {
                MainView()
                    .environment(\.loginStatus, $loginViewmodel.isLogin)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
