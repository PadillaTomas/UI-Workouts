import SwiftUI

/// Layer 2 — a large selectable option (plan mode, starting week). Selected =
/// accent border + checkmark. `compact` tightens it for list use.
public struct WKChoiceCard: View {
    private let title: String
    private let detail: String?
    private let isSelected: Bool
    private let compact: Bool
    private let action: () -> Void

    public init(
        title: String,
        body: String? = nil,
        isSelected: Bool,
        compact: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.detail = body
        self.isSelected = isSelected
        self.compact = compact
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: WKSpace.md) {
                VStack(alignment: .leading, spacing: compact ? 2 : WKSpace.xs) {
                    Text(title)
                        .wkFont(compact ? .body : .headline)
                        .foregroundStyle(WKColor.textPrimary)
                    if let detail {
                        Text(detail)
                            .wkFont(.callout)
                            .foregroundStyle(WKColor.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: WKSpace.sm)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? WKColor.accent : WKColor.border)
            }
            .padding(compact ? WKSpace.md : WKSpace.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(WKColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                    .strokeBorder(isSelected ? WKColor.accent.opacity(0.5) : WKColor.border,
                                  lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(WKPressStyle())
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview {
    VStack(spacing: WKSpace.md) {
        WKChoiceCard(title: "3-Day Plan",
                     body: "A rest day between each session. We schedule your week.",
                     isSelected: true) {}
        WKChoiceCard(title: "Free Run",
                     body: "Work through the plan at your own pace. No calendar.",
                     isSelected: false) {}
        WKChoiceCard(title: "Week 3", body: "20 min continuous by the end",
                     isSelected: false, compact: true) {}
    }
    .padding(WKSpace.lg)
    .background(WKColor.bg)
}
