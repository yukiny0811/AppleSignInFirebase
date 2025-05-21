//
//  File.swift
//  AppleSignInFirebase
//
//  Created by Yuki Kuwashima on 2025/05/21.
//

import SwiftUI
import FirebaseAuth

@Observable
@MainActor
public class AuthManager {

    public var user: User? = nil

    public var isSignedIn: Bool {
        user != nil
    }

    @ObservationIgnored
    private var handle: AuthStateDidChangeListenerHandle?

    public static let shared = AuthManager()

    private init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }

    public func signOut() throws {
        try Auth.auth().signOut()
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
