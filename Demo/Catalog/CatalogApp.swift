import SwiftUI
import UIWorkouts

/// A throwaway host app whose only job is to render `WKCatalogView` so the design
/// system can be browsed on a real simulator or device — the iOS equivalent of
/// opening Storybook. Not shipped anywhere; not a consumer of note.
@main
struct CatalogApp: App {
    @State private var theme: WKThemeMode = .system

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WKCatalogView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Picker("Theme", selection: $theme) {
                                ForEach(WKThemeMode.allCases) { Text($0.label).tag($0) }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .navigationTitle("UIWorkouts")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .wkThemeMode(theme)
        }
    }
}
