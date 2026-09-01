import SwiftUI

/// Layer 2 — a 1…N rating selector (post-workout effort). Generic range + end
/// labels; nothing about running. Each step is tinted by its position on
/// ``WKRamp`` (cool → warm); the selected step fills with that colour.
public struct WKScaleSelector: View {
    private let range: ClosedRange<Int>
    private let endLabels: (low: String, high: String)
    @Binding private var selection: Int

    public init(
        range: ClosedRange<Int> = 1...10,
        selection: Binding<Int>,
        endLabels: (low: String, high: String)
    ) {
        self.range = range
        self._selection = selection
        self.endLabels = endLabels
    }

    public var body: some View {
        VStack(spacing: WKSpace.sm) {
            HStack(spacing: WKSpace.xs) {
                ForEach(Array(range), id: \.self) { value in
                    let isOn = value == selection
                    let position = range.upperBound > range.lowerBound
                        ? Double(value - range.lowerBound)
                            / Double(range.upperBound - range.lowerBound)
                        : 0
                    Button {
                        selection = value
                    } label: {
                        Text("\(value)")
                            .font(.system(size: 15, weight: .medium, design: .monospaced))
                            .foregroundStyle(isOn ? WKColor.bg : WKRamp.stop(at: position))
                            .frame(maxWidth: .infinity, minHeight: WKSize.minTarget)
                            .background(isOn ? WKRamp.stop(at: position) : WKColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: WKRadius.chip,
                                                        style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: WKRadius.chip, style: .continuous)
                                    .strokeBorder(WKColor.border, lineWidth: isOn ? 0 : 1)
                            )
                    }
                    .buttonStyle(WKPressStyle())
                    .accessibilityLabel("\(value)")
                    .accessibilityAddTraits(isOn ? [.isSelected] : [])
                }
            }
            HStack {
                Text(endLabels.low).wkFont(.caption).foregroundStyle(WKColor.textTertiary)
                Spacer()
                Text(endLabels.high).wkFont(.caption).foregroundStyle(WKColor.textTertiary)
            }
        }
    }
}

#Preview {
    WKScaleSelector(selection: .constant(6), endLabels: ("Easy", "All out"))
        .padding(WKSpace.lg)
        .background(WKColor.bg)
}
