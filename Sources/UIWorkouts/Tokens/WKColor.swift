import SwiftUI

/// Layer 0 — semantic color roles for the "Ambient Dark" visual language, the
/// system's **single appearance**. No light/dark split — every value is one
/// fixed color and call sites never branch on `colorScheme`.
///
/// These are the only colors the system uses. Saturated hues appear solely
/// through ``WKPhase``, ``WKRamp``, ``accent``, ``stateDone`` and ``danger``.
public enum WKColor {
    /// App background — near-black. `#0B0C0C`
    public static let bg = Color(rgb: 0x0B0C0C)
    /// Raised surface (cards, sheets). `#1C1D1F`
    public static let surface = Color(rgb: 0x1C1D1F)
    /// Surface sitting on a surface — floating bars, the confirm card, a value
    /// bubble, a card on a card. `#212325`
    public static let surfaceRaised = Color(rgb: 0x212325)
    /// Recessed surface (wells, segmented-toggle track). `#131415`
    public static let surfaceSunken = Color(rgb: 0x131415)

    /// Primary text — warm cream, never pure white. `#F2EDE5`
    public static let textPrimary = Color(rgb: 0xF2EDE5)
    /// Secondary text. `#A7A39C`
    public static let textSecondary = Color(rgb: 0xA7A39C)
    /// Tertiary text / mono labels. `#6F6C67`
    public static let textTertiary = Color(rgb: 0x6F6C67)

    /// Hairline borders and dividers. Cards carry no hairline — separation comes
    /// from the surface value — but dividers and inset groups still use it. `#2C2E31`
    public static let border = Color(rgb: 0x2C2E31)
    /// Interactive *values*, links and selection marks only — a time, "Available",
    /// "Learn more", a selected check. **Never a button fill** (the primary button
    /// is cream). `#5AA9E8`
    public static let accent = Color(rgb: 0x5AA9E8)
    /// "Completed" state — cream, not green. Done reads as cream + a check +
    /// reduced opacity, not as a colour. Green is now ``WKPhase/walk``. `#F2EDE5`
    public static let stateDone = Color(rgb: 0xF2EDE5)
    /// Destructive actions (reset, delete). A muted brick red. `#D9736B`
    public static let danger = Color(rgb: 0xD9736B)
}
