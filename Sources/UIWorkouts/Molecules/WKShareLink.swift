import SwiftUI

/// Layer 2 — a `ShareLink` for a rendered image (a summary card, a chart).
/// Wraps SwiftUI's `ShareLink` so the system share sheet, its preview thumbnail
/// and iPad popover anchoring all behave correctly — only the trigger looks like
/// the rest of the design system.
///
/// Two shapes, chosen by whether a `label` is given:
/// - **labelled** — a full-width capsule styled as ``WKButton``'s `.secondary`
///   (surface fill, hairline border). The bottom-of-screen "Share" action.
/// - **icon only** (`label: nil`) — a `WKSize.minTarget` round button, for a
///   toolbar or the top corner of a detail view.
public struct WKShareLink: View {
    private let image: Image
    private let previewTitle: String
    private let label: String?

    public init(image: Image, previewTitle: String, label: String? = nil) {
        self.image = image
        self.previewTitle = previewTitle
        self.label = label
    }

    public var body: some View {
        ShareLink(item: image, preview: SharePreview(previewTitle, image: image)) {
            if let label {
                labelled(label)
            } else {
                icon
            }
        }
        .buttonStyle(WKPressStyle())
    }

    private func labelled(_ label: String) -> some View {
        HStack(spacing: WKSpace.sm) {
            Image(systemName: "square.and.arrow.up")
            Text(label)
        }
        .wkFont(.body)
        .foregroundStyle(WKColor.textPrimary)
        .frame(maxWidth: .infinity)
        .frame(height: WKSize.rowHeight)
        .background(WKColor.surface)
        .overlay(Capsule(style: .continuous).strokeBorder(WKColor.border, lineWidth: 1))
        .clipShape(Capsule(style: .continuous))
        .contentShape(Capsule(style: .continuous))
    }

    private var icon: some View {
        Image(systemName: "square.and.arrow.up")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(WKColor.textPrimary)
            .frame(width: WKSize.minTarget, height: WKSize.minTarget)
            .background(WKColor.surface, in: Circle())
            .overlay(Circle().strokeBorder(WKColor.border, lineWidth: 1))
            .contentShape(Circle())
    }
}

#Preview {
    VStack(spacing: WKSpace.xl) {
        WKShareLink(
            image: Image(systemName: "figure.boxing"),
            previewTitle: "My workout",
            label: "Share workout"
        )
        HStack {
            Spacer()
            WKShareLink(image: Image(systemName: "figure.boxing"), previewTitle: "My workout")
        }
    }
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
