import SwiftUI

/// Layer 1 — a settings row with a trailing toggle, tinted `stateDone` when on.
public struct WKToggleRow: View {
    private let title: String
    @Binding private var isOn: Bool

    public init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .wkFont(.body)
                .foregroundStyle(WKColor.textPrimary)
        }
        .tint(WKColor.stateDone)
        .frame(minHeight: WKSize.minTarget)
        .padding(.horizontal, WKSpace.lg)
    }
}

/// Layer 1 — a settings / disclosure row: title left, optional value + chevron
/// right. Tapping fires `action`.
public struct WKNavRow: View {
    private let title: String
    private let value: String?
    private let action: () -> Void

    public init(_ title: String, value: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: WKSpace.sm) {
                Text(title)
                    .wkFont(.body)
                    .foregroundStyle(WKColor.textPrimary)
                Spacer(minLength: WKSpace.sm)
                if let value {
                    Text(value)
                        .wkFont(.body)
                        .foregroundStyle(WKColor.textSecondary)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(WKColor.textTertiary)
            }
            .frame(minHeight: WKSize.minTarget)
            .padding(.horizontal, WKSpace.lg)
            .contentShape(Rectangle())
        }
        .buttonStyle(WKPressStyle())
    }
}

#Preview {
    VStack(spacing: 0) {
        WKNavRow("Mode", value: "3-Day Plan") {}
        Divider().overlay(WKColor.border)
        WKNavRow("Week starts", value: "Monday") {}
        Divider().overlay(WKColor.border)
        WKToggleRow("Interval tones", isOn: .constant(true))
    }
    .background(WKColor.surface)
    .padding(WKSpace.lg)
    .background(WKColor.bg)
}
