import SwiftUI

/// Layer 0 — motion tokens (canvas section 1a). Components should fall back to
/// `nil`/no animation when `\.accessibilityReduceMotion` is set.
public enum WKMotion {
    /// The default: unhurried, matches the app's calm tone.
    public static let calm: Animation = .easeOut(duration: 0.35)
    /// Per-second timer updates — quick, no bounce.
    public static let tick: Animation = .easeOut(duration: 0.15)
}
