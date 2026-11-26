import SwiftUI

@main
struct LetnieApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .letnieTheme(state)
        }
    }
}
