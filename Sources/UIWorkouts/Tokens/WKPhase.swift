import SwiftUI

/// The one domain-ish enum in the system, kept deliberately generic: a small set
/// of named workout states, each carrying a color pair and a spoken label.
/// Adding a workout type later means adding a case here — no call site changes.
public enum WKPhase: String, CaseIterable, Sendable, Hashable {
    case run
    case walk

    /// The saturated phase color. Also used for the ``WKTimerDial`` phase eyebrow,
    /// so the light value is deliberately dark enough to pass AA as text on `bg`.
    /// dark `run` `#E8A33D` / `walk` `#5FC9AE`; light `run` `#9A6220` / `walk` `#1F6B57`.
    public var color: Color {
        switch self {
        case .run: return Color(light: 0x9A6220, dark: 0xE8A33D)   // amber
        case .walk: return Color(light: 0x1F6B57, dark: 0x5FC9AE)  // teal
        }
    }

    /// The tinted "soft" fill for backgrounds behind the phase color.
    /// dark `run` `#2A1D12` / `walk` `#12262B`; light `run` `#F6E9D6` / `walk` `#DCEFE9`.
    public var softColor: Color {
        switch self {
        case .run: return Color(light: 0xF6E9D6, dark: 0x2A1D12)
        case .walk: return Color(light: 0xDCEFE9, dark: 0x12262B)
        }
    }

    /// Readable text/icon color for content sitting on ``softColor``.
    /// dark `run` `#E8A33D` / `walk` `#5FC9AE`; light `run` `#8A5716` / `walk` `#1F6B57`.
    public var onSoftColor: Color {
        switch self {
        case .run: return Color(light: 0x8A5716, dark: 0xE8A33D)
        case .walk: return Color(light: 0x1F6B57, dark: 0x5FC9AE)
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
