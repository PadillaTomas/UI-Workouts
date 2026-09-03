import SwiftUI

/// Layer 2 — a one-time-unlock paywall screen. Pure presentation: it renders the
/// pitch and calls back on **buy**, **restore** and **close**. Every bit of
/// StoreKit — products, prices, entitlement — lives in the consuming app; this
/// takes only the resolved strings.
///
/// Two placements:
/// - **filled into a locked area** (`onClose == nil`) — no close control, fills
///   the space where the gated content would be.
/// - **presented as a sheet** (`onClose` set) — a close button, top-trailing.
public struct WKPaywall: View {
    /// One selling point: an SF Symbol and a line (or two) of copy.
    public struct Feature: Identifiable {
        public let id = UUID()
        public let systemImage: String
        public let title: String
        public let detail: String?

        public init(systemImage: String, title: String, detail: String? = nil) {
            self.systemImage = systemImage
            self.title = title
            self.detail = detail
        }
    }

    /// A small link under the footer — Terms, Privacy Policy, etc. Opens the URL
    /// in the browser.
    public struct LegalLink: Identifiable {
        public let id = UUID()
        public let label: String
        public let url: URL

        public init(_ label: String, _ url: URL) {
            self.label = label
            self.url = url
        }
    }

    private let title: String
    private let subtitle: String?
    private let features: [Feature]
    private let priceLabel: String
    private let ctaLabel: String
    private let restoreLabel: String
    private let legalLinks: [LegalLink]
    private let isPurchasing: Bool
    private let onPurchase: () -> Void
    private let onRestore: () -> Void
    private let onClose: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        features: [Feature],
        priceLabel: String,
        ctaLabel: String,
        restoreLabel: String,
        legalLinks: [LegalLink] = [],
        isPurchasing: Bool = false,
        onPurchase: @escaping () -> Void,
        onRestore: @escaping () -> Void,
        onClose: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.features = features
        self.priceLabel = priceLabel
        self.ctaLabel = ctaLabel
        self.restoreLabel = restoreLabel
        self.legalLinks = legalLinks
        self.isPurchasing = isPurchasing
        self.onPurchase = onPurchase
        self.onRestore = onRestore
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            if let onClose {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(WKColor.textTertiary)
                            .frame(width: WKSize.minTarget, height: WKSize.minTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(WKPressStyle())
                    .accessibilityLabel("Close")
                }
                .padding(.horizontal, WKSpace.sm)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: WKSpace.xl) {
                    VStack(alignment: .leading, spacing: WKSpace.xs) {
                        Text(title)
                            .wkFont(.titleL)
                            .foregroundStyle(WKColor.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        if let subtitle {
                            Text(subtitle)
                                .wkFont(.body)
                                .foregroundStyle(WKColor.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    VStack(alignment: .leading, spacing: WKSpace.lg) {
                        ForEach(features) { feature in
                            HStack(alignment: .top, spacing: WKSpace.md) {
                                Image(systemName: feature.systemImage)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(WKColor.accent)
                                    .frame(width: 28)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(feature.title)
                                        .wkFont(.headline)
                                        .foregroundStyle(WKColor.textPrimary)
                                    if let detail = feature.detail {
                                        Text(detail)
                                            .wkFont(.callout)
                                            .foregroundStyle(WKColor.textSecondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, WKSpace.lg)
                .padding(.top, WKSpace.md)
                .padding(.bottom, WKSpace.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(spacing: WKSpace.sm) {
                Text(priceLabel)
                    .wkFont(.callout)
                    .foregroundStyle(WKColor.textSecondary)
                    .padding(.bottom, WKSpace.xs)
                WKButton(ctaLabel, style: .primary, size: .regular,
                         isLoading: isPurchasing, action: onPurchase)
                Button(action: onRestore) {
                    Text(restoreLabel)
                        .wkFont(.callout)
                        .foregroundStyle(WKColor.accent)
                        .frame(minHeight: WKSize.minTarget)
                }
                .buttonStyle(.plain)
                .disabled(isPurchasing)

                if !legalLinks.isEmpty {
                    HStack(spacing: WKSpace.xs) {
                        ForEach(Array(legalLinks.enumerated()), id: \.element.id) { index, link in
                            if index > 0 {
                                Text("·").foregroundStyle(WKColor.textTertiary)
                            }
                            Link(link.label, destination: link.url)
                                .foregroundStyle(WKColor.textTertiary)
                        }
                    }
                    .wkFont(.caption)
                }
            }
            .padding(.horizontal, WKSpace.lg)
            .padding(.top, WKSpace.lg)
            // In a sheet the bottom safe area already sits above the home
            // indicator — extra padding just inflates the footer. In a tab the
            // footer needs to clear the tab bar itself.
            .padding(.bottom, onClose == nil ? WKSpace.lg : 0)
            .frame(maxWidth: .infinity)
            .background(WKColor.surface)
        }
        .background(WKColor.bg)
        .accessibilityElement(children: .contain)
    }
}

#Preview("Locked tab") {
    WKPaywall(
        title: "Track your training with Rounds Pro",
        subtitle: "Every workout you finish, remembered.",
        features: [
            .init(systemImage: "clock.arrow.circlepath", title: "Activity history",
                  detail: "Every finished workout, with weekly and total counts."),
            .init(systemImage: "calendar", title: "Calendar",
                  detail: "See your training on a month grid."),
            .init(systemImage: "heart.fill", title: "Apple Health",
                  detail: "Send finished workouts to the Health app."),
            .init(systemImage: "square.and.arrow.up", title: "Share card",
                  detail: "A clean summary image for anywhere."),
        ],
        priceLabel: "$3.99 · one-time, yours forever",
        ctaLabel: "Unlock Rounds Pro",
        restoreLabel: "Restore Purchase",
        legalLinks: [
            .init("Terms of Use", URL(string: "https://example.com/terms")!),
            .init("Privacy Policy", URL(string: "https://example.com/privacy")!),
        ],
        onPurchase: {},
        onRestore: {}
    )
    .preferredColorScheme(.dark)
}

#Preview("Sheet") {
    WKPaywall(
        title: "Rounds Pro",
        features: [
            .init(systemImage: "clock.arrow.circlepath", title: "Activity history"),
            .init(systemImage: "calendar", title: "Calendar"),
        ],
        priceLabel: "$3.99 · one-time",
        ctaLabel: "Unlock",
        restoreLabel: "Restore Purchase",
        isPurchasing: true,
        onPurchase: {},
        onRestore: {},
        onClose: {}
    )
    .preferredColorScheme(.dark)
}
