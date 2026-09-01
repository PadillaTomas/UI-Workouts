import SwiftUI

/// Layer 2 — the standard modal container. Every `.sheet { … }` in the ecosystem
/// wraps its content in a `WKSheet` so sheets share one layout: a
/// ``WKSheetHeader`` (close/back · centred title · optional trailing action), a
/// hairline, then the scrolling content on a ``WKColor/surface`` panel that
/// reads as lifted off the app background.
///
/// ```swift
/// .sheet(isPresented: $showing) {
///     WKSheet(title: "Session detail", onClose: { showing = false }) {
///         // your content — already inside a ScrollView, padded WKSpace.xl
///     }
///     .presentationDetents([.medium, .large])
/// }
/// ```
public struct WKSheet<Content: View>: View {
    private let title: String
    private let leading: WKSheetHeader.Leading
    private let onLeading: () -> Void
    private let trailingLabel: String?
    private let trailingEnabled: Bool
    private let onTrailing: (() -> Void)?
    private let scrolls: Bool
    private let content: Content

    /// - Parameters:
    ///   - scrolls: wrap the content in a `ScrollView` (default `true`). Pass
    ///     `false` when the content manages its own scrolling or must not scroll.
    public init(
        title: String,
        leading: WKSheetHeader.Leading = .close,
        onClose: @escaping () -> Void,
        trailingLabel: String? = nil,
        trailingEnabled: Bool = true,
        onTrailing: (() -> Void)? = nil,
        scrolls: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.leading = leading
        self.onLeading = onClose
        self.trailingLabel = trailingLabel
        self.trailingEnabled = trailingEnabled
        self.onTrailing = onTrailing
        self.scrolls = scrolls
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            WKSheetHeader(
                title: title,
                leading: leading,
                onLeading: onLeading,
                trailingLabel: trailingLabel,
                trailingEnabled: trailingEnabled,
                onTrailing: onTrailing
            )
            Rectangle()
                .fill(WKColor.border)
                .frame(height: 1)
                .accessibilityHidden(true)

            if scrolls {
                ScrollView { padded }
            } else {
                padded
            }
        }
        .background(WKColor.surface)
        .presentationBackground(WKColor.surface)
        .presentationDragIndicator(.hidden)
    }

    private var padded: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(WKSpace.xl)
    }
}

#Preview {
    Color.black
        .sheet(isPresented: .constant(true)) {
            WKSheet(title: "Week 2 · Day 1", onClose: {}) {
                VStack(alignment: .leading, spacing: WKSpace.xl) {
                    WKPill("Today", tone: .run)
                    VStack(spacing: 0) {
                        WKMetricRow(title: "Time", value: "22:14")
                        WKMetricRow(title: "Felt", value: "6 — Steady")
                        WKMetricRow(title: "Status", value: "Done")
                    }
                    Text("3 min run / 90 sec walk × 5")
                        .wkFont(.body).foregroundStyle(WKColor.textSecondary)
                }
            }
            .presentationDetents([.medium, .large])
        }
}
