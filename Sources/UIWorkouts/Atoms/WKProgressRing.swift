import SwiftUI

/// Layer 1 — a circular progress arc over a track ring. Rounded cap, starts at
/// 12 o'clock. Purely presentational.
public struct WKProgressRing: View {
    private let fraction: Double
    private let tint: Color
    private let track: Color
    private let lineWidth: CGFloat

    public init(
        fraction: Double,
        tint: Color = WKColor.accent,
        track: Color = WKColor.border,
        lineWidth: CGFloat = 8
    ) {
        self.fraction = min(1, max(0, fraction))
        self.tint = tint
        self.track = track
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: WKSpace.xl) {
        WKProgressRing(fraction: 0.3).frame(width: 120, height: 120)
        WKProgressRing(fraction: 0.66, tint: WKPhase.walk.color)
            .frame(width: 120, height: 120)
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
