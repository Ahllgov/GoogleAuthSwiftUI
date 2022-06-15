//
//  LoginPage.swift
//  GoogleAuthSwiftUI
//
//  Created by Магомед Ахильгов on 16.06.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginPage: View {
    
    @State var isLoading: Bool = false
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        VStack {
            Image("onBoard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: getRect().height / 4, alignment: .bottom)
                .background(
                    Circle()
                        .fill(Color("lightBlue"))
                        .scaleEffect(2, anchor: .bottom)
                        .offset(y: 20)
                )
            
            VStack(spacing: 20) {
                
                Text("We have over \n10,000 tasks for you!")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .kerning(1.1)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Button {
                    handleLogin()
                } label: {
                    HStack(spacing: 15) {
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                        Text("Create an Account")
                            .font(.title3)
                            .fontWeight(.medium)
                            .kerning(1.1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .strokeBorder(.blue)
                    )
                }
                .padding(.top)
                
                Text(getAttributedString(string: "By creating an account, you are agreeing to out Terms of service"))
                    .font(.body.bold())
                    .foregroundColor(.gray)
                    .kerning(1.1)
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
            }
            .padding()
            .padding(.top, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(
            ZStack {
                if isLoading {
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(.white)
                        .cornerRadius(10)
                }
            }
        )
    }
    
    func getAttributedString(string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        if let range = attributedString.range(of: "Terms of service") {
            attributedString[range].foregroundColor = .black
            attributedString[range].font = .body.bold()
        }
        
        return attributedString
    }
    
    func handleLogin() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
               return
             }

             guard
                let authentication = user?.authentication,
               let idToken = authentication.idToken
             else {
                 isLoading = false
               return
             }

             let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                            accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { result, err in
                
                isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                   return
                 }
                guard let user = result?.user else {
                    return
                }
                
                print(user.displayName ?? "Success!")
                
                withAnimation {
                    logStatus = true
                }
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
