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
    @State var themeColors = getThemeColors()
    
    private var logoImage: some View {
        Image("\(loginViewmodel.getLoginThemeImage())")
    }
    
    private var logoLabel: some View {
        HStack(spacing: 3) {
            Text("Let's")
            Text("Git")
                .fontWeight(.bold)
            Text("it!")
        }
        .font(.system(size: 12))
        .padding([.top], -20)
        .padding([.bottom], 20)
    }
    
    private var loginButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 211, height: 34)
                .foregroundColor(themeColors[4])
            Text("Login with Github")
        }
        .onAppear(perform: {
            themeColors = getThemeColors()
        })
        .onTapGesture {
            loginViewmodel.githubLogin()
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.white)
    }
    
    private var loginView: some View {
        VStack (alignment: .center) {
            logoImage
            logoLabel
            loginButton
        }
    }
    
    var body: some View {
        Group {
            if loginViewmodel.isProgress {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                if loginViewmodel.isLogin == false {
                    loginView
                } else {
                    MainTabView()
                        .environment(\.loginStatus, $loginViewmodel.isLogin)
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
