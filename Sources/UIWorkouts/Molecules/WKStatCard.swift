import SwiftUI

/// Layer 2 — a 2-up metric tile (handoff spec §4): a mono eyebrow over a large
/// light value, with an optional status chip and an info/chevron affordance.
/// Designed to sit two-across in an `HStack`, or full width alone.
public struct WKStatCard: View {
    public enum Accessory { case none, info, chevron }

    private let caption: String
    private let value: String
    private let chip: (text: String, tone: WKPill.Tone)?
    private let accessory: Accessory
    private let action: (() -> Void)?

    public init(
        caption: String,
        value: String,
        chip: (text: String, tone: WKPill.Tone)? = nil,
        accessory: Accessory = .none,
        action: (() -> Void)? = nil
    ) {
        self.caption = caption
        self.value = value
        self.chip = chip
        self.accessory = accessory
        self.action = action
    }

    public var body: some View {
        let card = WKCard(padding: WKSpace.lg) {
            VStack(alignment: .leading, spacing: WKSpace.sm) {
                HStack {
                    Text(caption)
                        .wkFont(.labelMono)
                        .foregroundStyle(WKColor.textTertiary)
                    Spacer(minLength: WKSpace.xs)
                    accessoryIcon
                }
                Text(value)
                    .wkFont(.metricL)
                    .foregroundStyle(WKColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if let chip {
                    WKStatChip(chip.text, tone: chip.tone)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())

        Group {
            if let action {
                Button(action: action) { card }.buttonStyle(WKPressStyle())
            } else {
                card
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(caption)
        .accessibilityValue(chip.map { "\(value), \($0.text)" } ?? value)
        .accessibilityAddTraits(action != nil ? [.isButton] : [])
    }

    @ViewBuilder private var accessoryIcon: some View {
        switch accessory {
        case .none: EmptyView()
        case .info:
            Image(systemName: "info.circle").font(.system(size: 15))
                .foregroundStyle(WKColor.textTertiary)
        case .chevron:
            Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold))
                .foregroundStyle(WKColor.textTertiary)
        }
    }
}

#Preview {
    HStack(spacing: WKSpace.md) {
        WKStatCard(caption: "Total time", value: "8h 20m",
                   chip: ("On track", .walk), accessory: .info)
        WKStatCard(caption: "Sessions", value: "12", accessory: .chevron) {}
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
