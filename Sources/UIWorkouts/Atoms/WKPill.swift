import SwiftUI

/// Layer 1 — a small status label with a soft tinted fill.
public struct WKPill: View {
    public enum Tone: Equatable {
        case run, walk, done, neutral, accent
        /// A stop on ``WKRamp`` (index clamped into range). Fill only — the label
        /// steps to the darker end so it stays legible.
        case ramp(Int)

        var background: Color {
            switch self {
            case .run: return WKPhase.run.softColor
            case .walk: return WKPhase.walk.softColor
            case .done: return WKColor.surfaceRaised
            case .neutral: return WKColor.surfaceSunken
            case .accent: return WKColor.accent.opacity(0.16)
            case .ramp(let i): return Self.rampColor(i).opacity(0.18)
            }
        }

        var foreground: Color {
            switch self {
            case .run: return WKPhase.run.onSoftColor
            case .walk: return WKPhase.walk.onSoftColor
            case .done: return WKColor.stateDone
            case .neutral: return WKColor.textSecondary
            case .accent: return WKColor.accent
            case .ramp(let i): return Self.rampColor(i)
            }
        }

        private static func rampColor(_ index: Int) -> Color {
            let clamped = min(WKRamp.stops.count - 1, max(0, index))
            return WKRamp.stops[clamped]
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
