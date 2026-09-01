import SwiftUI

/// Layer 2 — a modal header (handoff spec §4): leading close/back, centred title,
/// optional trailing action that is `accent` when enabled and `textTertiary`
/// when not — the reference's "Cancel · Edit activity goal · Save".
public struct WKSheetHeader: View {
    public enum Leading { case close, back }

    private let title: String
    private let leading: Leading
    private let onLeading: () -> Void
    private let trailingLabel: String?
    private let trailingEnabled: Bool
    private let onTrailing: (() -> Void)?

    public init(
        title: String,
        leading: Leading = .close,
        onLeading: @escaping () -> Void,
        trailingLabel: String? = nil,
        trailingEnabled: Bool = true,
        onTrailing: (() -> Void)? = nil
    ) {
        self.title = title
        self.leading = leading
        self.onLeading = onLeading
        self.trailingLabel = trailingLabel
        self.trailingEnabled = trailingEnabled
        self.onTrailing = onTrailing
    }

    public var body: some View {
        ZStack {
            Text(title)
                .wkFont(.headline)
                .foregroundStyle(WKColor.textPrimary)
                .lineLimit(1)
                .accessibilityAddTraits(.isHeader)

            HStack {
                Button(action: onLeading) {
                    leadingLabel
                        .frame(minWidth: WKSize.minTarget, minHeight: WKSize.minTarget,
                               alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(WKPressStyle())
                .accessibilityLabel(leading == .close ? "Close" : "Back")

                Spacer()

                if let trailingLabel, let onTrailing {
                    Button(action: onTrailing) {
                        Text(trailingLabel)
                            .wkFont(.body)
                            .foregroundStyle(trailingEnabled ? WKColor.accent
                                                             : WKColor.textTertiary)
                            .frame(minWidth: WKSize.minTarget, minHeight: WKSize.minTarget,
                                   alignment: .trailing)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(WKPressStyle())
                    .disabled(!trailingEnabled)
                }
            }
        }
        .padding(.horizontal, WKSpace.lg)
        .frame(height: WKSize.timerControl)
    }

    @ViewBuilder private var leadingLabel: some View {
        switch leading {
        case .close:
            Image(systemName: "xmark")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(WKColor.textSecondary)
        case .back:
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(WKColor.textSecondary)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        WKSheetHeader(title: "Edit activity goal", onLeading: {},
                      trailingLabel: "Save", trailingEnabled: false, onTrailing: {})
        WKSheetHeader(title: "Personalize", leading: .back, onLeading: {},
                      trailingLabel: "Save", trailingEnabled: true, onTrailing: {})
    }
    .background(WKColor.bg)
}
