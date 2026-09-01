import SwiftUI

/// Quiet secondary text row surfacing optional HealthKit context (Couch to Hour
/// CTH-28) — a leading icon and a "·"-joined line, flat on the background like
/// ``WKMetricRow``, never inside a card. Renders nothing when there are no
/// segments, so a call site can drop it in unconditionally.
public struct WKHealthContextRow: View {
    private let label: String
    private let segments: [String]

    /// - Parameters:
    ///   - label: the leading word, e.g. "Health" — passed in already localized,
    ///     this component never owns copy.
    ///   - segments: already-formatted pieces, e.g. `["4.1 km", "5:34 /km", "141 bpm avg"]`.
    ///     Empty renders nothing.
    public init(label: String, segments: [String]) {
        self.label = label
        self.segments = segments
    }

    public var body: some View {
        if segments.isEmpty {
            EmptyView()
        } else {
            HStack(spacing: WKSpace.xs) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 12))
                Text(([label] + segments).joined(separator: " · "))
                    .wkFont(.caption)
            }
            .foregroundStyle(WKColor.textTertiary)
            .accessibilityElement(children: .combine)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: WKSpace.lg) {
        WKHealthContextRow(label: "Health", segments: ["4.1 km", "5:34 /km", "141 bpm avg"])
        WKHealthContextRow(label: "Health", segments: ["141 bpm avg"])
        WKHealthContextRow(label: "Health", segments: [])
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
