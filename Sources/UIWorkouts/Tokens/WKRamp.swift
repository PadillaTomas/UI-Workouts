import SwiftUI

/// Layer 0 — an ordered cool→warm ramp (handoff spec §2.3). The only source of
/// hue in the system besides ``WKColor/accent``, ``WKColor/danger`` and
/// ``WKPhase``. Used by ``WKArcGauge`` bands, ``WKPill/Tone/ramp(_:)`` and any
/// future chart. Index 0 = lowest.
///
/// Ramp stops are **fills and strokes, not text** — several are below 4.5:1 as
/// type. Where a ramp colour must read as a value, pair it with a ``WKStatChip``
/// tint or step to the darker end.
public enum WKRamp {
    /// The five ordered stops, cool → hot. Light values step darker so the ramp
    /// keeps its ordering against a pale background.
    public static let stops: [Color] = [
        Color(light: 0x3C7A9C, dark: 0x4A8FB5), // cool
        Color(light: 0x2E8C74, dark: 0x5FC9AE), // teal
        Color(light: 0x93911F, dark: 0xC9C86A), // neutral
        Color(light: 0xA9722A, dark: 0xD9A05B), // warm
        Color(light: 0xA64A42, dark: 0xC4635B), // hot
    ]

    /// Nearest stop for a `0…1` position.
    public static func stop(at fraction: Double) -> Color {
        guard !stops.isEmpty else { return WKColor.textPrimary }
        let clamped = min(1, max(0, fraction))
        let index = Int((clamped * Double(stops.count - 1)).rounded())
        return stops[min(stops.count - 1, max(0, index))]
    }

    /// Continuous interpolation between adjacent stops, for gradients and
    /// sparklines. Falls back to the nearest stop on platforms without
    /// `Color.resolve`.
    public static func interpolated(at fraction: Double) -> Color {
        guard stops.count > 1 else { return stop(at: fraction) }
        let clamped = min(1, max(0, fraction))
        let scaled = clamped * Double(stops.count - 1)
        let lower = Int(scaled.rounded(.down))
        let upper = min(stops.count - 1, lower + 1)
        let t = scaled - Double(lower)
        #if canImport(UIKit)
        let a = UIColor(stops[lower])
        let b = UIColor(stops[upper])
        var (ar, ag, ab, aa): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (br, bg, bb, ba): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        a.getRed(&ar, green: &ag, blue: &ab, alpha: &aa)
        b.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
        let f = CGFloat(t)
        return Color(.sRGB,
                     red: Double(ar + (br - ar) * f),
                     green: Double(ag + (bg - ag) * f),
                     blue: Double(ab + (bb - ab) * f),
                     opacity: Double(aa + (ba - aa) * f))
        #else
        return t < 0.5 ? stops[lower] : stops[upper]
        #endif
    }
}
