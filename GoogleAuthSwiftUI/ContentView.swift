//
//  ContentView.swift
//  GoogleAuthSwiftUI
//
//  Created by Магомед Ахильгов on 16.06.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        if logStatus {
            NavigationView {
                VStack(spacing: 15) {
                    Text("Logged in")
                    
                    Button {
                        GIDSignIn.sharedInstance.signOut()
                        try? Auth.auth().signOut()
                        
                        withAnimation {
                            logStatus = false
                        }
                    } label: {
                        Text("Logout")
                    }
                }
            }
        } else {
            LoginPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
