import SwiftUI

/// Layer 1 — a small status label with a soft tinted fill.
public struct WKPill: View {
    public enum Tone {
        case run, walk, done, neutral

        var background: Color {
            switch self {
            case .run: return WKPhase.run.softColor
            case .walk: return WKPhase.walk.softColor
            case .done: return Color(light: 0xEAF0E8, dark: 0x22301F)
            case .neutral: return WKColor.surfaceSunken
            }
        }

        var foreground: Color {
            switch self {
            case .run: return WKPhase.run.onSoftColor
            case .walk: return WKPhase.walk.onSoftColor
            case .done: return WKColor.stateDone
            case .neutral: return WKColor.textSecondary
            }
        }
    }

    private let text: String
    private let tone: Tone

    public init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .wkFont(.labelMono)
            .foregroundStyle(tone.foreground)
            .padding(.horizontal, WKSpace.md)
            .padding(.vertical, WKSpace.xs + 2)
            .background(tone.background, in: Capsule(style: .continuous))
    }
}

#Preview {
    HStack(spacing: WKSpace.sm) {
        WKPill("5 of 10", tone: .run)
        WKPill("6 of 10", tone: .walk)
        WKPill("Done", tone: .done)
        WKPill("Rest", tone: .neutral)
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
