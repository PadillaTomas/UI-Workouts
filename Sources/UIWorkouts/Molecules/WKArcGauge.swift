import SwiftUI

/// Layer 2 — an arc gauge (handoff spec §4): a partial ring with the two end
/// labels at the arc tips, and a mono eyebrow + large light value centred in the
/// bowl. The right read for a *goal* — progress toward a target — as opposed to
/// ``WKTimerDial``'s full ring for "time left".
///
/// The default `sweep` is a clean 180° semicircle: the track starts on the
/// horizontal, runs over the top and ends on the horizontal, and `fraction == 1`
/// fills exactly that arc.
public struct WKArcGauge: View {
    public struct Segment {
        public let fraction: Double
        public let color: Color
        public init(fraction: Double, color: Color) {
            self.fraction = min(1, max(0, fraction))
            self.color = color
        }
    }

    private let fraction: Double
    private let value: String
    private let caption: String?
    private let bounds: (String, String)?
    private let sweepDeg: Double
    private let diameter: CGFloat
    private let segments: [Segment]
    private let tint: Color
    private let showsKnob: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        fraction: Double,
        value: String,
        caption: String? = nil,
        bounds: (String, String)? = nil,
        sweep: Angle = .degrees(180),
        diameter: CGFloat = WKSize.gaugeDiameter,
        segments: [Segment] = [],
        tint: Color = WKColor.textPrimary,
        showsKnob: Bool = true
    ) {
        self.fraction = min(1, max(0, fraction))
        self.value = value
        self.caption = caption
        self.bounds = bounds
        self.sweepDeg = min(300, max(60, sweep.degrees))
        self.diameter = diameter
        self.segments = segments
        self.tint = tint
        self.showsKnob = showsKnob
    }

    private let lineWidth: CGFloat = 12

    /// Radius of the arc's circle. The circle is centred horizontally and its
    /// centre sits `lineWidth/2 + radius` down from the top of the drawing box.
    private var radius: CGFloat { (diameter - lineWidth) / 2 }
    private var centerY: CGFloat { lineWidth / 2 + radius }

    /// SwiftUI `Path` angles: 0° = 3 o'clock, increasing clockwise on screen
    /// (270° = top). A symmetric arc centred on the top runs `270 ± sweep/2`.
    private func angle(at f: Double) -> Double { (270 - sweepDeg / 2) + f * sweepDeg }

    /// How far the arc dips below its centre line (only when sweep > 180°).
    private var bottomDip: CGFloat {
        guard sweepDeg > 180 else { return 0 }
        return max(0, CGFloat(sin(angle(at: 1) * .pi / 180))) * radius
    }

    private var regionHeight: CGFloat {
        centerY + lineWidth / 2 + max(bottomDip, diameter * 0.14)
    }

    public var body: some View {
        VStack(spacing: WKSpace.xs) {
            ZStack {
                Arc(sweepDeg: sweepDeg, from: 0, to: 1, lineWidth: lineWidth)
                    .stroke(WKColor.border,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

                ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                    Arc(sweepDeg: sweepDeg, from: 0, to: segment.fraction, lineWidth: lineWidth)
                        .stroke(segment.color.opacity(0.35),
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .accessibilityHidden(true)
                }

                Arc(sweepDeg: sweepDeg, from: 0, to: fraction, lineWidth: lineWidth)
                    .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

                if showsKnob {
                    Circle()
                        .fill(WKColor.surfaceRaised)
                        .overlay(Circle().strokeBorder(tint, lineWidth: 3))
                        .frame(width: lineWidth + 6, height: lineWidth + 6)
                        .position(knobPoint)
                        .accessibilityHidden(true)
                }

                VStack(spacing: WKSpace.xs) {
                    if let caption {
                        Text(caption)
                            .wkFont(.labelMono)
                            .foregroundStyle(WKColor.textTertiary)
                    }
                    Text(value)
                        .wkFont(.metricXL)
                        .foregroundStyle(WKColor.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: diameter * 0.8)
                .position(x: diameter / 2, y: centerY - radius * 0.18)
            }
            .frame(width: diameter, height: regionHeight)

            if let bounds {
                HStack {
                    Text(bounds.0)
                    Spacer()
                    Text(bounds.1)
                }
                .wkFont(.caption)
                .foregroundStyle(WKColor.textTertiary)
                .frame(width: diameter)
                .padding(.horizontal, lineWidth / 2)
            }
        }
        .animation(reduceMotion ? nil : WKMotion.calm, value: fraction)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(caption ?? "Progress")
        .accessibilityValue(accessibleValue)
    }

    private var knobPoint: CGPoint {
        let a = angle(at: fraction) * .pi / 180
        return CGPoint(
            x: diameter / 2 + CGFloat(cos(a)) * radius,
            y: centerY + CGFloat(sin(a)) * radius
        )
    }

    private var accessibleValue: String {
        if let bounds { return "\(value) of \(bounds.1)" }
        return "\(Int((fraction * 100).rounded())) percent"
    }

    /// Symmetric arc centred on the top of its rect, spanning `sweepDeg`.
    /// `from`/`to` are `0…1` positions along that span.
    private struct Arc: Shape {
        var sweepDeg: Double
        var from: Double
        var to: Double
        var lineWidth: CGFloat

        func path(in rect: CGRect) -> Path {
            let r = (rect.width - lineWidth) / 2
            let center = CGPoint(x: rect.midX, y: lineWidth / 2 + r)
            let start = 270 - sweepDeg / 2
            var path = Path()
            path.addArc(
                center: center,
                radius: r,
                startAngle: .degrees(start + from * sweepDeg),
                endAngle: .degrees(start + to * sweepDeg),
                clockwise: false
            )
            return path
        }
    }
}

#Preview {
    VStack(spacing: WKSpace.xxl) {
        WKArcGauge(
            fraction: 0.72,
            value: "72",
            caption: "PLAN PROGRESS",
            bounds: ("0", "100"),
            segments: [.init(fraction: 1, color: WKRamp.stops[1])]
        )
        WKArcGauge(fraction: 0.4, value: "8", caption: "WEEK", bounds: ("1", "20"),
                   sweep: .degrees(240), showsKnob: false)
    }
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
