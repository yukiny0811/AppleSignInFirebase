//
//  SignInWithAppleFirebase.swift
//  AppleSignInFirebase
//
//  Created by Yuki Kuwashima on 2025/05/21.
//

import SwiftUI
import FirebaseAuth
import CryptoKit
import AuthenticationServices

public struct SignInWithAppleFirebaseButton: View {

    @Environment(\.colorScheme) var colorScheme
    var isDarkMode: Bool { colorScheme == .dark }

    @State var currentNonce: String?

    public init() {}

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    public var body: some View {
        VStack {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.email, .fullName]
                let nonce = randomNonceString()
                currentNonce = nonce
                request.nonce = sha256(nonce)
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential
                    guard let nonce = currentNonce else {
                        break
                    }
                    guard let appleIDToken = appleIDCredential?.identityToken else {
                        break
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        break
                    }
                    let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                    Auth.auth().signIn(with: credential) { result, error in
                        if result?.user != nil {
                            print("Logged In!")
                        }
                    }
                case .failure(let error):
                    print("Login Error! \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(isDarkMode ? .white : .black)
            .frame(width: 224, height: 40)
        }
    }
}
