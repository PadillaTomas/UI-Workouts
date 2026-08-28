import SwiftUI

/// Layer 1 — the base surface container: `surface` fill, 1px `border`, card radius.
public struct WKCard<Content: View>: View {
    private let padding: CGFloat
    private let content: Content

    public init(padding: CGFloat = WKSpace.lg, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(WKColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                    .strokeBorder(WKColor.border, lineWidth: 1)
            )
    }
}

#Preview {
    WKCard {
        VStack(alignment: .leading, spacing: WKSpace.xs) {
            Text("7 sessions done").wkFont(.callout).foregroundStyle(WKColor.textPrimary)
            Text("Week 2 of 6. Nothing to catch up on.")
                .wkFont(.caption).foregroundStyle(WKColor.textSecondary)
        }
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
