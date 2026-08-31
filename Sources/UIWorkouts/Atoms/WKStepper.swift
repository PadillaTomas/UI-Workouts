import SwiftUI

/// Layer 1 — a horizontal −/value/+ stepper for a small integer.
///
/// `range` clamps both ends (the matching button disables at the bound).
public struct WKStepper: View {
    @Binding private var value: Int
    private let range: ClosedRange<Int>
    private let step: Int

    public init(value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) {
        self._value = value
        self.range = range
        self.step = step
    }

    public var body: some View {
        HStack(spacing: WKSpace.sm) {
            button("minus") { value = max(range.lowerBound, value - step) }
                .disabled(value <= range.lowerBound)
            Text("\(value)")
                .wkFont(.headline)
                .monospacedDigit()
                .foregroundStyle(WKColor.textPrimary)
                .frame(minWidth: 72)
                .contentTransition(.numericText())
            button("plus") { value = min(range.upperBound, value + step) }
                .disabled(value >= range.upperBound)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityValue("\(value)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: value = min(range.upperBound, value + step)
            case .decrement: value = max(range.lowerBound, value - step)
            @unknown default: break
            }
        }
    }

    private func button(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button { withAnimation(.snappy) { action() } } label: {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 40, height: 40)
                .foregroundStyle(WKColor.textPrimary)
                .background(WKColor.surfaceSunken, in: Circle())
                .overlay(Circle().strokeBorder(WKColor.border, lineWidth: 1))
                .contentShape(Circle())
        }
        .buttonStyle(WKPressStyle())
    }
}

#Preview {
    struct Demo: View {
        @State private var rounds = 12
        @State private var sets = 3
        var body: some View {
            VStack(spacing: WKSpace.xl) {
                WKStepper(value: $rounds, in: 1...99)
                WKStepper(value: $sets, in: 1...10)
            }
            .padding(WKSpace.xl)
            .background(WKColor.bg)
        }
    }
    return Demo()
}
