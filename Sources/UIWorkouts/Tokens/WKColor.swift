import SwiftUI

/// Layer 0 — semantic color roles for the "Ambient Dark" visual language. Dark
/// is the **primary theme**; a light appearance is carried alongside it and
/// stays AA. Every value is a `light` / `dark` pair that resolves itself against
/// the trait environment — call sites read the token and never branch on
/// `colorScheme`.
///
/// Saturated hues appear solely through ``WKPhase``, ``WKRamp``, ``accent``,
/// ``stateDone`` and ``danger``.
public enum WKColor {
    /// App background — near-black in dark, warm off-white in light.
    /// `#0B0C0C` / `#F7F4EF`
    public static let bg = Color(light: 0xF7F4EF, dark: 0x0B0C0C)
    /// Raised surface (cards, sheets). `#1C1D1F` / `#FFFFFF`
    public static let surface = Color(light: 0xFFFFFF, dark: 0x1C1D1F)
    /// Surface sitting on a surface — floating bars, the confirm card, a value
    /// bubble, a card on a card. `#212325` / `#FFFFFF`
    public static let surfaceRaised = Color(light: 0xFFFFFF, dark: 0x212325)
    /// Recessed surface (wells, segmented-toggle track). `#131415` / `#EFEBE4`
    public static let surfaceSunken = Color(light: 0xEFEBE4, dark: 0x131415)

    /// Primary text — warm cream in dark, near-black ink in light.
    /// `#F2EDE5` / `#17181A`
    public static let textPrimary = Color(light: 0x17181A, dark: 0xF2EDE5)
    /// Secondary text. `#A7A39C` / `#5F5B55`
    public static let textSecondary = Color(light: 0x5F5B55, dark: 0xA7A39C)
    /// Tertiary text / mono labels. `#6F6C67` / `#8E8A83`
    public static let textTertiary = Color(light: 0x8E8A83, dark: 0x6F6C67)

    /// Hairline borders and dividers. Cards carry no hairline in dark —
    /// separation comes from the surface value — but light cards, dividers and
    /// inset groups still use it. `#2C2E31` / `#E2DCD3`
    public static let border = Color(light: 0xE2DCD3, dark: 0x2C2E31)
    /// Interactive *values*, links and selection marks only — a time, "Available",
    /// "Learn more", a selected check. **Never a button fill** (the primary button
    /// is cream/ink). `#5AA9E8` / `#1F6698` (light fixed up from a sub-AA draft).
    public static let accent = Color(light: 0x1F6698, dark: 0x5AA9E8)
    /// "Completed" state — cream/ink, not green. Done reads as the primary text
    /// colour + a check + reduced opacity, not as a colour. Green is
    /// ``WKPhase/walk``. `#F2EDE5` / `#17181A`
    public static let stateDone = Color(light: 0x17181A, dark: 0xF2EDE5)
    /// Destructive actions (reset, delete). A muted brick red. `#D9736B` / `#B2453D`
    public static let danger = Color(light: 0xB2453D, dark: 0xD9736B)
}
