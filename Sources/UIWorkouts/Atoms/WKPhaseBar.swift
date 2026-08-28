import SwiftUI

/// Layer 1 — a single rounded capsule filled with a phase color. The building
/// block of ``WKSegmentedTrack`` and the leading marker on ``WKIntervalRow``.
public struct WKPhaseBar: View {
    private let phase: WKPhase
    private let height: CGFloat
    private let filled: Bool

    public init(phase: WKPhase, height: CGFloat = 8, filled: Bool = true) {
        self.phase = phase
        self.height = height
        self.filled = filled
    }

    public var body: some View {
        Capsule(style: .continuous)
            .fill(filled ? phase.color : phase.softColor)
            .frame(height: height)
            .accessibilityLabel(phase.label)
    }
}

#Preview {
    VStack(spacing: WKSpace.md) {
        WKPhaseBar(phase: .run)
        WKPhaseBar(phase: .walk)
        WKPhaseBar(phase: .run, height: 40, filled: false)
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
