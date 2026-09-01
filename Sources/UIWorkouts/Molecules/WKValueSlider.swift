import SwiftUI

/// Layer 2 — a slider with a value bubble above the thumb and min / suggested /
/// max labels below (handoff spec §4). The reference's "300 Cal" goal editor.
/// Track is ``WKColor/accent``; the bubble is a ``WKColor/surfaceRaised`` pill.
public struct WKValueSlider: View {
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let format: (Double) -> String
    private let suggested: Double?
    private let ticks: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1,
        format: @escaping (Double) -> String,
        suggested: Double? = nil,
        ticks: Int = 0
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.format = format
        self.suggested = suggested
        self.ticks = ticks
    }

    private let thumbSize: CGFloat = 26
    private let trackHeight: CGFloat = 6

    private var fraction: Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return min(1, max(0, (value - range.lowerBound) / span))
    }

    public var body: some View {
        VStack(spacing: WKSpace.sm) {
            GeometryReader { geo in
                let usable = geo.size.width - thumbSize
                let x = thumbSize / 2 + usable * fraction

                ZStack(alignment: .leading) {
                    Capsule().fill(WKColor.surfaceSunken).frame(height: trackHeight)
                    Capsule().fill(WKColor.accent)
                        .frame(width: max(trackHeight, x), height: trackHeight)

                    if ticks > 1 {
                        tickMarks(usable: usable)
                    }

                    Circle()
                        .fill(WKColor.surfaceRaised)
                        .overlay(Circle().strokeBorder(WKColor.accent, lineWidth: 3))
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: x - thumbSize / 2)
                        .overlay(alignment: .bottom) {
                            bubble.offset(x: x - thumbSize / 2, y: -thumbSize - 4)
                        }
                }
                .frame(height: geo.size.height, alignment: .center)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { g in update(at: g.location.x, usable: usable) }
                )
            }
            .frame(height: thumbSize + 28)

            HStack {
                Text(format(range.lowerBound))
                Spacer()
                if let suggested {
                    Text("Suggested \(format(suggested))")
                        .foregroundStyle(WKColor.accent)
                    Spacer()
                }
                Text(format(range.upperBound))
            }
            .wkFont(.caption)
            .foregroundStyle(WKColor.textTertiary)
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(format(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: value = min(range.upperBound, value + step)
            case .decrement: value = max(range.lowerBound, value - step)
            default: break
            }
        }
    }

    private var bubble: some View {
        Text(format(value))
            .wkFont(.labelMono)
            .foregroundStyle(WKColor.textPrimary)
            .padding(.horizontal, WKSpace.sm)
            .padding(.vertical, WKSpace.xs)
            .background(WKColor.surfaceRaised, in: Capsule(style: .continuous))
            .fixedSize()
    }

    private func tickMarks(usable: CGFloat) -> some View {
        ForEach(0..<ticks, id: \.self) { i in
            let f = Double(i) / Double(ticks - 1)
            Circle().fill(WKColor.border).frame(width: 3, height: 3)
                .offset(x: thumbSize / 2 + usable * f - 1.5)
        }
    }

    private func update(at locationX: CGFloat, usable: CGFloat) {
        guard usable > 0 else { return }
        let f = min(1, max(0, (locationX - thumbSize / 2) / usable))
        let raw = range.lowerBound + Double(f) * (range.upperBound - range.lowerBound)
        let stepped = (raw / step).rounded() * step
        let clamped = min(range.upperBound, max(range.lowerBound, stepped))
        if clamped != value {
            withAnimation(reduceMotion ? nil : WKMotion.tick) { value = clamped }
        }
    }
}

#Preview {
    struct Demo: View {
        @State var cal = 300.0
        var body: some View {
            WKValueSlider(value: $cal, range: 100...650, step: 10,
                          format: { "\(Int($0)) Cal" }, suggested: 300)
                .padding(WKSpace.xl)
                .background(WKColor.bg)
        }
    }
    return Demo()
}
