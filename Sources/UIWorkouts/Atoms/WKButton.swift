import SwiftUI

/// Layer 1 — the system button.
///
/// - `primary`   filled, inverted text — the one main action on a screen.
/// - `secondary` surface fill + hairline border.
/// - `soft`      tinted fill (used for "Pause" — `WKPhase.run.softColor`).
/// - `quiet`     text only, secondary color — low-stakes ("Skip for now").
///
/// States shipped: rest, pressed (0.97 scale, 0.9 opacity), disabled (40%),
/// loading (spinner replaces the label, control still sized).
public struct WKButton<Label: View>: View {
    public enum Style { case primary, secondary, soft, quiet }

    public enum Size {
        /// 64pt — timer controls / hero CTA.
        case large
        /// 56pt — standard CTA.
        case regular
        /// 44pt — compact.
        case compact

        var height: CGFloat {
            switch self {
            case .large: return 64
            case .regular: return 56
            case .compact: return 44
            }
        }
    }

    private let style: Style
    private let size: Size
    private let isLoading: Bool
    private let action: () -> Void
    private let label: Label

    @Environment(\.isEnabled) private var isEnabled

    public init(
        style: Style = .primary,
        size: Size = .regular,
        isLoading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                label
                    .wkFont(.body)
                    .opacity(isLoading ? 0 : 1)
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(foreground)
                }
            }
            .frame(maxWidth: style == .quiet ? nil : .infinity)
            .frame(height: size.height)
            .padding(.horizontal, style == .quiet ? WKSpace.sm : WKSpace.lg)
            .foregroundStyle(foreground)
            .background(background)
            .overlay(border)
            .clipShape(Capsule(style: .continuous))
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(WKPressStyle())
        .disabled(isLoading)
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
    }

    private var foreground: Color {
        switch style {
        case .primary: return WKColor.bg
        case .secondary: return WKColor.textPrimary
        case .soft: return WKPhase.run.onSoftColor
        case .quiet: return WKColor.textSecondary
        }
    }

    @ViewBuilder private var background: some View {
        switch style {
        case .primary: WKColor.textPrimary
        case .secondary: WKColor.surface
        case .soft: WKPhase.run.softColor
        case .quiet: Color.clear
        }
    }

    @ViewBuilder private var border: some View {
        if style == .secondary {
            Capsule(style: .continuous).strokeBorder(WKColor.border, lineWidth: 1)
        }
    }
}

public extension WKButton where Label == Text {
    /// Convenience: a plain-text button.
    init(
        _ title: String,
        style: Style = .primary,
        size: Size = .regular,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(style: style, size: size, isLoading: isLoading, action: action) {
            Text(title)
        }
    }
}

/// Press feedback shared by the system's tappable surfaces.
struct WKPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(reduceMotion ? nil : WKMotion.tick, value: configuration.isPressed)
    }
}

#Preview("WKButton") {
    VStack(spacing: WKSpace.md) {
        WKButton("Start session", style: .primary, size: .large) {}
        WKButton("Mark done", style: .secondary) {}
        WKButton("Pause", style: .soft) {}
        WKButton("Skip for now", style: .quiet, size: .compact) {}
        WKButton("Loading", style: .primary, isLoading: true) {}
        WKButton("Disabled", style: .primary) {}.disabled(true)
    }
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
