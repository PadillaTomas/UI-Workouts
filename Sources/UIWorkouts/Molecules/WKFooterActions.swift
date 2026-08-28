import SwiftUI

/// Layer 2 — the bottom action stack. Pins its content above the safe-area
/// inset and fades the scrolling content out behind it with a gradient over
/// `WKColor.bg`. Put ``WKButton``s inside.
public struct WKFooterActions<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: WKSpace.md) {
            content
        }
        .padding(.horizontal, WKSpace.lg)
        .padding(.top, WKSpace.xl)
        .padding(.bottom, WKSpace.md)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [WKColor.bg.opacity(0), WKColor.bg],
                startPoint: .top, endPoint: .init(x: 0.5, y: 0.4)
            )
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        WKColor.bg.ignoresSafeArea()
        WKFooterActions {
            WKButton("Start session", style: .primary, size: .large) {}
            WKButton("Mark interval done", style: .secondary) {}
        }
    }
}
