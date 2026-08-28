import SwiftUI

/// The one domain-ish enum in the system, kept deliberately generic: a small set
/// of named workout states, each carrying a color pair and a spoken label.
/// Adding a workout type later means adding a case here — no call site changes.
public enum WKPhase: String, CaseIterable, Sendable, Hashable {
    case run
    case walk

    /// The saturated phase color. `run` `#C4703C`/`#E08A52`, `walk` `#3D7A96`/`#6BA9C4`.
    public var color: Color {
        switch self {
        case .run: return Color(light: 0xC4703C, dark: 0xE08A52)
        case .walk: return Color(light: 0x3D7A96, dark: 0x6BA9C4)
        }
    }

    /// The tinted "soft" fill for backgrounds behind the phase color.
    /// `run` `#F7E7DA`/`#3A2618`, `walk` `#DFEBF1`/`#172B34`.
    public var softColor: Color {
        switch self {
        case .run: return Color(light: 0xF7E7DA, dark: 0x3A2618)
        case .walk: return Color(light: 0xDFEBF1, dark: 0x172B34)
        }
    }

    /// Readable text/icon color for content sitting on ``softColor``.
    public var onSoftColor: Color {
        switch self {
        case .run: return Color(light: 0x9E5427, dark: 0xE08A52)
        case .walk: return Color(light: 0x2C5C72, dark: 0x6BA9C4)
        }
    }

    /// Human label. Phase is never signalled by color alone — components pair
    /// this with the color and with position in a track.
    public var label: String {
        switch self {
        case .run: return "Run"
        case .walk: return "Walk"
        }
    }
}
