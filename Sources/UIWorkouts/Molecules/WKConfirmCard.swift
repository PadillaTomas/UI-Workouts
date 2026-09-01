import SwiftUI

/// Layer 2 — a floating dual-action confirm card (handoff spec §4). Fills
/// ``WKColor/surfaceRaised``, floats over content with a shadow. The reference's
/// "Running · 7:10 AM · 34m / Confirm / Edit"; Couch to Hour use: "You missed
/// Tuesday — Mark done / Skip".
public struct WKConfirmCard: View {
    private let title: String
    private let detail: String?
    private let primaryLabel: String
    private let onPrimary: () -> Void
    private let secondaryLabel: String?
    private let onSecondary: (() -> Void)?
    private let onDismiss: (() -> Void)?

    public init(
        title: String,
        detail: String? = nil,
        primaryLabel: String,
        onPrimary: @escaping () -> Void,
        secondaryLabel: String? = nil,
        onSecondary: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.detail = detail
        self.primaryLabel = primaryLabel
        self.onPrimary = onPrimary
        self.secondaryLabel = secondaryLabel
        self.onSecondary = onSecondary
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.md) {
            HStack(alignment: .top, spacing: WKSpace.sm) {
                VStack(alignment: .leading, spacing: WKSpace.xs) {
                    Text(title)
                        .wkFont(.headline)
                        .foregroundStyle(WKColor.textPrimary)
                    if let detail {
                        Text(detail)
                            .wkFont(.callout)
                            .foregroundStyle(WKColor.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                if let onDismiss {
                    Spacer(minLength: WKSpace.sm)
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(WKColor.textTertiary)
                            .frame(width: WKSize.minTarget, height: WKSize.minTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(WKPressStyle())
                    .accessibilityLabel("Dismiss")
                }
            }
            HStack(spacing: WKSpace.sm) {
                WKButton(primaryLabel, style: .primary, size: .compact, action: onPrimary)
                if let secondaryLabel, let onSecondary {
                    WKButton(secondaryLabel, style: .secondary, size: .compact,
                             action: onSecondary)
                }
            }
        }
        .padding(WKSpace.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(WKColor.surfaceRaised)
        .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
        .shadow(color: .black.opacity(0.28), radius: 24, y: 8)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    ZStack {
        WKColor.bg.ignoresSafeArea()
        WKConfirmCard(
            title: "You missed Tuesday",
            detail: "Mark it done if you ran anyway, or skip it and keep your schedule.",
            primaryLabel: "Mark done",
            onPrimary: {},
            secondaryLabel: "Skip",
            onSecondary: {},
            onDismiss: {}
        )
        .padding(WKSpace.xl)
    }
}
