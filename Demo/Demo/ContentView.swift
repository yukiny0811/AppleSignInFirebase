//
//  ContentView.swift
//  Demo
//
//  Created by Yuki Kuwashima on 2025/02/14.
//

import SwiftUI
import AppleSignInFirebase

struct ContentView: View {

    @Environment(AuthManager.self) var authManager

    var body: some View {
        if authManager.isSignedIn {
            Text("Signed In!")
            Button("Sign Out") {
                try? authManager.signOut()
            }
            .buttonStyle(.borderedProminent)
        } else {
            SignInWithAppleFirebaseButton()
        }
    }
}
