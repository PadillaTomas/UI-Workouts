import SwiftUI

/// Layer 1 — the base surface container: `surface` fill, card radius. In dark
/// there is **no hairline** — separation comes from the surface value, as in the
/// reference. In light the surface sits too close to `bg`, so a `border` hairline
/// is added there (and only there).
public struct WKCard<Content: View>: View {
    private let padding: CGFloat
    private let content: Content

    @Environment(\.colorScheme) private var colorScheme

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
            .overlay {
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                        .strokeBorder(WKColor.border, lineWidth: 1)
                }
            }
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
