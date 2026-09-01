import SwiftUI

/// Layer 0 — the type scale ("Ambient Dark", handoff spec §2.6).
///
/// Three faces, three jobs, no overlap:
/// - **DM Mono** — countdowns and uppercase metric eyebrows. Not section headers.
/// - **Instrument Serif** — the single reassuring headline on a screen. Never a
///   control label, never twice on one screen, never below 28pt.
/// - **DM Sans** — everything else, plus the big light metric numerals.
///
/// All bundled (`Resources/Fonts/`) and registered on first use
/// (``WKFontRegistration``); a consuming app needs no `UIAppFonts` entry.
/// Sizes are *fixed* (`Font.custom(_:fixedSize:)`) — Dynamic Type scaling is a
/// separate change. `.monospacedDigit()` is kept everywhere the design calls for
/// tabular figures.
public enum WKFont: CaseIterable, Sendable {
    /// Big timer readout. Mono 92, tight tracking, tabular, cap at Dynamic Type XL.
    case timerDisplay
    /// Session-total / secondary timer. Mono 44, tabular.
    case timerSecondary
    /// Gauge centre value. Light sans 72, tabular.
    case metricXL
    /// ``WKStatCard`` value. Light sans 40, tabular.
    case metricL
    /// The one reassuring serif headline on a screen. Serif 44.
    case displayL
    /// Serif headline, medium. Serif 34.
    case displayM
    /// Serif headline, small — the floor for the serif face. Serif 28.
    case displayS
    case titleL
    case titleM
    case headline
    /// Default reading size.
    case body
    case callout
    case caption
    /// Uppercase mono metric eyebrow (`STEPS`, `DURATION`). Not section headers.
    case labelMono

    /// Which registered family a spec resolves against.
    enum Family { case sans, mono, serif }

    var spec: Spec {
        switch self {
        case .timerDisplay:
            return Spec(size: 92, weight: .light, family: .mono, tracking: -3.7,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xLarge)
        case .timerSecondary:
            return Spec(size: 44, weight: .light, family: .mono, tracking: -1.3,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xxLarge)
        case .metricXL:
            return Spec(size: 72, weight: .light, family: .sans, tracking: -2.0,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xLarge)
        case .metricL:
            return Spec(size: 40, weight: .light, family: .sans, tracking: -1.0,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xxLarge)
        case .displayL:
            return Spec(size: 44, weight: .regular, family: .serif, tracking: -0.5,
                       lineSpacing: 2, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .displayM:
            return Spec(size: 34, weight: .regular, family: .serif, tracking: -0.4,
                       lineSpacing: 2, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .displayS:
            return Spec(size: 28, weight: .regular, family: .serif, tracking: -0.3,
                       lineSpacing: 2, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .titleL:
            return Spec(size: 34, weight: .medium, family: .sans, tracking: -0.7,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .titleM:
            return Spec(size: 28, weight: .medium, family: .sans, tracking: -0.55,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .headline:
            return Spec(size: 20, weight: .medium, family: .sans, tracking: 0,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .body:
            return Spec(size: 17, weight: .regular, family: .sans, tracking: 0,
                       lineSpacing: 5, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .callout:
            return Spec(size: 15, weight: .regular, family: .sans, tracking: 0,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .caption:
            return Spec(size: 13, weight: .regular, family: .sans, tracking: 0,
                       lineSpacing: 3, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .labelMono:
            return Spec(size: 12, weight: .regular, family: .mono, tracking: 1.44,
                       lineSpacing: 0, uppercase: true, tabular: false, dynamicTypeCap: nil)
        }
    }

    struct Spec {
        var size: CGFloat
        var weight: Font.Weight
        var family: Family
        var tracking: CGFloat
        var lineSpacing: CGFloat
        var uppercase: Bool
        var tabular: Bool
        var dynamicTypeCap: DynamicTypeSize?

        var font: Font {
            _ = WKFontRegistration.run
            switch family {
            case .mono:
                // DM Mono ships as separate static faces — address by PostScript
                // name (Light / Medium have their own family names).
                let face: String
                switch weight {
                case .light, .ultraLight, .thin: face = "DMMono-Light"
                case .medium, .semibold, .bold, .heavy, .black: face = "DMMono-Medium"
                default: face = "DMMono-Regular"
                }
                return .custom(face, fixedSize: size)
            case .serif:
                // Instrument Serif ships Regular + Italic; weight is not an axis.
                return .custom("Instrument Serif", fixedSize: size)
            case .sans:
                // DM Sans is the variable face — `.weight` drives the `wght` axis.
                return .custom("DM Sans", fixedSize: size).weight(weight)
            }
        }
    }
}
