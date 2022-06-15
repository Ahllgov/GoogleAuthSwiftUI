//
//  GoogleAuthSwiftUIApp.swift
//  GoogleAuthSwiftUI
//
//  Created by Магомед Ахильгов on 16.06.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct GoogleAuthSwiftUIApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
