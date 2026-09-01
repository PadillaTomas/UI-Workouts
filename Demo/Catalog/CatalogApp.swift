import SwiftUI
import UIWorkouts

/// A throwaway host app whose only job is to render `WKCatalogView` so the design
/// system can be browsed on a real simulator or device — the iOS equivalent of
/// opening Storybook. Not shipped anywhere; not a consumer of note.
@main
struct CatalogApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WKCatalogView()
                    .navigationTitle("UIWorkouts")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .preferredColorScheme(.dark)
        }
    }
}
