import SwiftUI

/// Layer 2 — a hairline-divided inset row group for Settings (handoff spec §4).
///
/// **Not derived from the reference** — the reference stacks separate cards with
/// gaps and no dividers. Kept because Settings wants a native-iOS grouped list.
/// The header renders **sentence-case sans** (`.callout` in `textSecondary`), not
/// mono. Fill ``WKColor/surface``, radius ``WKRadius/group``, 1pt full-bleed
/// dividers in ``WKColor/border`` between rows. Rows carry their own uniform
/// metrics (``WKSize/rowHeight``), so this just stacks them and draws the
/// dividers — a bare `WKInsetGroup { … }` with no header is identical to the
/// same rows stacked anywhere else.
public struct WKInsetGroup<Content: View>: View {
    private let header: String?
    private let footer: String?
    private let content: Content

    public init(
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.footer = footer
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.sm) {
            if let header {
                Text(header)
                    .wkFont(.callout)
                    .foregroundStyle(WKColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, WKSpace.md)
                    .accessibilityAddTraits(.isHeader)
            }

            _VariadicView.Tree(DividedRows()) {
                content
            }
            .background(WKColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: WKRadius.group, style: .continuous))

            if let footer {
                Text(footer)
                    .wkFont(.caption)
                    .foregroundStyle(WKColor.textTertiary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, WKSpace.md)
            }
        }
        .accessibilityElement(children: .contain)
    }

    private struct DividedRows: _VariadicView.MultiViewRoot {
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            let last = children.last?.id
            VStack(spacing: 0) {
                ForEach(children) { child in
                    child
                    if child.id != last {
                        Rectangle()
                            .fill(WKColor.border)
                            .frame(height: 1)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }
}

#Preview {
    struct Demo: View {
        @State var tones = true
        @State var haptics = false
        var body: some View {
            VStack(spacing: WKSpace.xl) {
                WKInsetGroup(header: "During a session",
                             footer: "Tones play at each interval change.") {
                    WKToggleRow("Interval tones", isOn: $tones)
                    WKToggleRow("Haptics", isOn: $haptics)
                    WKNavRow("Countdown", value: "3 seconds") {}
                }
            }
            .padding(WKSpace.lg)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(WKColor.bg)
        }
    }
    return Demo()
}
