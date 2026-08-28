import SwiftUI

/// Layer 2 — an uppercase mono section label with breathing room above it.
public struct WKSectionHeader: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .wkFont(.labelMono)
            .foregroundStyle(WKColor.textTertiary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}

/// Layer 2 — the standard screen top block: optional eyebrow, title, optional body.
public struct WKScreenHeader: View {
    private let eyebrow: String?
    private let title: String
    private let detail: String?

    public init(eyebrow: String? = nil, title: String, body: String? = nil) {
        self.eyebrow = eyebrow
        self.title = title
        self.detail = body
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.xs) {
            if let eyebrow {
                WKLabelMono(eyebrow)
            }
            Text(title)
                .wkFont(.titleL)
                .foregroundStyle(WKColor.textPrimary)
                .accessibilityAddTraits(.isHeader)
            if let detail {
                Text(detail)
                    .wkFont(.body)
                    .foregroundStyle(WKColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: WKSpace.xl) {
        WKScreenHeader(eyebrow: "Wednesday", title: "Week 2, Day 1",
                       body: "22 minutes · 5 run intervals")
        WKSectionHeader("During a session")
    }
    .padding(WKSpace.lg)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(WKColor.bg)
}
