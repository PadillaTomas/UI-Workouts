import SwiftUI

/// Layer 2 — label + value + optional full-width progress underline (handoff
/// spec §4). Sits **flat on the background, not inside a card** — that is how the
/// reference's Contributors list reads. Tappable when `action` is non-nil.
public struct WKMetricRow: View {
    private let title: String
    private let value: String
    private let fraction: Double?
    private let tint: Color
    private let showsChevron: Bool
    private let action: (() -> Void)?

    public init(
        title: String,
        value: String,
        fraction: Double? = nil,
        tint: Color = WKColor.textPrimary,
        showsChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.value = value
        self.fraction = fraction.map { min(1, max(0, $0)) }
        self.tint = tint
        self.showsChevron = showsChevron
        self.action = action
    }

    public var body: some View {
        let content = VStack(spacing: WKSpace.sm) {
            HStack(spacing: WKSpace.sm) {
                Text(title)
                    .wkFont(.body)
                    .foregroundStyle(WKColor.textPrimary)
                Spacer(minLength: WKSpace.sm)
                Text(value)
                    .wkFont(.body)
                    .foregroundStyle(WKColor.textSecondary)
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(WKColor.textTertiary)
                }
            }
            if let fraction {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(WKColor.border)
                        Capsule().fill(tint).frame(width: geo.size.width * fraction)
                    }
                }
                .frame(height: 4)
                .accessibilityHidden(true)
            }
        }
        .frame(minHeight: WKSize.minTarget)
        .contentShape(Rectangle())

        Group {
            if let action {
                Button(action: action) { content }.buttonStyle(WKPressStyle())
            } else {
                content
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(value)
        .accessibilityAddTraits(action != nil ? [.isButton] : [])
    }
}

#Preview {
    VStack(spacing: WKSpace.lg) {
        WKMetricRow(title: "Total sleep", value: "7h 42m", fraction: 0.82,
                    tint: WKPhase.walk.color)
        WKMetricRow(title: "Restfulness", value: "Good", fraction: 0.6)
        WKMetricRow(title: "Timing", value: "Optimal", showsChevron: true) {}
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
