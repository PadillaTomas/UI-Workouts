import SwiftUI

/// The user-facing appearance choice. The package does not own a theme
/// environment object — ``WKColor`` values adapt to the trait environment on
/// their own. This enum only drives `.preferredColorScheme` at the app root and
/// is what ``WKThemePicker`` edits.
public enum WKThemeMode: String, CaseIterable, Sendable, Identifiable {
    case system
    case light
    case dark

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    /// `nil` means "follow the system".
    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

public extension View {
    /// Apply a ``WKThemeMode`` at the app root.
    func wkThemeMode(_ mode: WKThemeMode) -> some View {
        preferredColorScheme(mode.colorScheme)
    }
}
