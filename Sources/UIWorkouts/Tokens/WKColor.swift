import SwiftUI

/// Layer 0 — semantic color roles. Every value resolves light/dark automatically.
/// Transcribed from the "Couch to Hour iOS design" canvas (section 1a).
///
/// These are the only colors the system uses. Saturated hues appear solely
/// through ``WKPhase``, ``stateDone`` and ``danger``.
public enum WKColor {
    /// App background. `#FAF8F5` / `#171614`
    public static let bg = Color(light: 0xFAF8F5, dark: 0x171614)
    /// Raised surface (cards, sheets). `#FFFFFF` / `#201E1B`
    public static let surface = Color(light: 0xFFFFFF, dark: 0x201E1B)
    /// Recessed surface (wells, done rows). `#F1EDE7` / `#292623`
    public static let surfaceSunken = Color(light: 0xF1EDE7, dark: 0x292623)

    /// Primary text. `#211E1A` / `#F4F1EC`
    public static let textPrimary = Color(light: 0x211E1A, dark: 0xF4F1EC)
    /// Secondary text. `#6E675E` / `#A9A29A`
    public static let textSecondary = Color(light: 0x6E675E, dark: 0xA9A29A)
    /// Tertiary text / mono labels. `#9A9288` / `#766F66`
    public static let textTertiary = Color(light: 0x9A9288, dark: 0x766F66)

    /// Hairline borders and dividers. `#E4DED5` / `#34302B`
    public static let border = Color(light: 0xE4DED5, dark: 0x34302B)
    /// The single brand accent (equals `phaseRun`). `#C4703C` / `#E08A52`
    public static let accent = Color(light: 0xC4703C, dark: 0xE08A52)
    /// "Completed" state. `#5B7A55` / `#8FAE87`
    public static let stateDone = Color(light: 0x5B7A55, dark: 0x8FAE87)
    /// Destructive actions (reset, delete). A muted brick red — reads as a
    /// warning without clashing with the warm palette or the ``accent`` orange.
    /// `#B23B3B` / `#E38A82`
    public static let danger = Color(light: 0xB23B3B, dark: 0xE38A82)
}
