//
//  DemoApp.swift
//  Demo
//
//  Created by Yuki Kuwashima on 2025/02/14.
//

import SwiftUI
import AppleSignInFirebase

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthManager.shared)
        }
    }
}
