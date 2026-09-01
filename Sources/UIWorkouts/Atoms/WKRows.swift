import SwiftUI

/// Uniform metrics for every settings row — ``WKToggleRow``, ``WKNavRow`` and any
/// future one. A single ``WKSize/rowHeight`` box, ``WKSpace/lg`` horizontal
/// padding, content vertically centred, so a 31pt switch and a 22pt label row
/// occupy the exact same space and line up — whether the row is standalone or
/// inside a ``WKInsetGroup``.
private struct WKRowMetrics: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, minHeight: WKSize.rowHeight, alignment: .leading)
            .padding(.horizontal, WKSpace.lg)
            .contentShape(Rectangle())
    }
}

public extension View {
    /// Apply the design system's settings-row metrics — a ``WKSize/rowHeight``
    /// box with ``WKSpace/lg`` horizontal padding and centred content. Use it on
    /// an app-specific row (a bespoke trailing control, a whole-row link) so it
    /// lines up with ``WKToggleRow`` / ``WKNavRow`` inside a ``WKInsetGroup``.
    func wkRowMetrics() -> some View { modifier(WKRowMetrics()) }
}

/// Layer 1 — a settings row with a trailing toggle, tinted `accent` when on.
/// (Not `stateDone`: that is cream, which would compete with the toggle's own
/// near-white thumb. `accent` is the active-control signal, as in the reference.)
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
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(WKColor.accent)
        .wkRowMetrics()
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
            .wkRowMetrics()
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
