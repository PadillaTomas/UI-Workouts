import SwiftUI

/// Layer 2 — a small tonal status chip (handoff spec §4). Distinct from
/// ``WKPill``: a chip radius, not a capsule. Reuses ``WKPill/Tone`` deliberately —
/// one tone vocabulary, two shapes. The reference's `Low` on a green tint.
public struct WKStatChip: View {
    private let text: String
    private let tone: WKPill.Tone

    public init(_ text: String, tone: WKPill.Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .wkFont(.labelMono)
            .foregroundStyle(tone.foreground)
            .padding(.horizontal, WKSpace.sm)
            .padding(.vertical, WKSpace.xs)
            .background(
                tone.background,
                in: RoundedRectangle(cornerRadius: WKRadius.chip, style: .continuous)
            )
            .accessibilityLabel(text)
    }
}

#Preview {
    HStack(spacing: WKSpace.sm) {
        WKStatChip("Low", tone: .walk)
        WKStatChip("Behind", tone: .ramp(4))
        WKStatChip("Optimal", tone: .accent)
        WKStatChip("Rest", tone: .neutral)
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
