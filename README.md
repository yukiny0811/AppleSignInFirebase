# AppleSignInFirebase

- Firebaseはセットアップ済み前提のライブラリです。(Firebase setup has to be finished before using this library)
- FirebaseConsoleでSignInWithAppleを有効にしてください。 (Enable SignInWithApple in Firebase Console)

## Usage

```swift
import SwiftUI
import AppleSignInFirebase

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthManager.shared) //important!
        }
    }
}
```

```swift
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
```
