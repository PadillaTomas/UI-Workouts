import SwiftUI

/// Layer 0 — the type scale (canvas section 1a).
///
/// The design specifies **DM Sans** (text) and **DM Mono** (timer + mono labels).
/// Until the `.ttf` files are dropped into `Resources/Fonts/` and registered,
/// these resolve to the system faces: `.default` for text and `.monospaced`
/// for the timer/mono styles, always with `.monospacedDigit()` where the design
/// calls for tabular figures. Swapping in the real faces later needs no API change.
public enum WKFont: CaseIterable, Sendable {
    /// Big timer readout. Mono 92, tight tracking, tabular, cap at Dynamic Type XL.
    case timerDisplay
    /// Session-total / secondary timer. Mono 44, tabular.
    case timerSecondary
    case titleL
    case titleM
    case headline
    /// Default reading size.
    case body
    case callout
    case caption
    /// Uppercase mono eyebrow / section label.
    case labelMono

    var spec: Spec {
        switch self {
        case .timerDisplay:
            return Spec(size: 92, weight: .light, mono: true, tracking: -3.7,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xLarge)
        case .timerSecondary:
            return Spec(size: 44, weight: .light, mono: true, tracking: -1.3,
                       lineSpacing: 0, uppercase: false, tabular: true, dynamicTypeCap: .xxLarge)
        case .titleL:
            return Spec(size: 34, weight: .medium, mono: false, tracking: -0.7,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .titleM:
            return Spec(size: 28, weight: .medium, mono: false, tracking: -0.55,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .headline:
            return Spec(size: 20, weight: .medium, mono: false, tracking: 0,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .body:
            return Spec(size: 17, weight: .regular, mono: false, tracking: 0,
                       lineSpacing: 5, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .callout:
            return Spec(size: 15, weight: .regular, mono: false, tracking: 0,
                       lineSpacing: 4, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .caption:
            return Spec(size: 13, weight: .regular, mono: false, tracking: 0,
                       lineSpacing: 3, uppercase: false, tabular: false, dynamicTypeCap: nil)
        case .labelMono:
            return Spec(size: 12, weight: .regular, mono: true, tracking: 1.44,
                       lineSpacing: 0, uppercase: true, tabular: false, dynamicTypeCap: nil)
        }
    }

    struct Spec {
        var size: CGFloat
        var weight: Font.Weight
        var mono: Bool
        var tracking: CGFloat
        var lineSpacing: CGFloat
        var uppercase: Bool
        var tabular: Bool
        var dynamicTypeCap: DynamicTypeSize?

        var font: Font {
            .system(size: size, weight: weight, design: mono ? .monospaced : .default)
        }
    }
}
