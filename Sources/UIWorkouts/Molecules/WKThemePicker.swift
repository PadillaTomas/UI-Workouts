import SwiftUI

/// The appearance a host app offers the user: follow the system, or pin one way.
/// `RawValue` is stable for persistence. Map to SwiftUI with ``colorScheme``.
public enum WKAppearance: String, CaseIterable, Sendable, Hashable {
    case system
    case light
    case dark

    /// The value to hand `.preferredColorScheme(_:)` — `nil` means "follow system".
    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// Layer 2 — the appearance switcher: a row of preview-swatch cards, one per
/// option, selected = ``WKColor/accent`` border. Presentation only; the parent
/// owns the ``WKAppearance`` binding (and its dark-by-default initial value).
public struct WKThemePicker: View {
    @Binding private var selection: WKAppearance
    private let options: [(value: WKAppearance, label: String)]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// - Parameters:
    ///   - selection: the bound appearance preference.
    ///   - options: the cards to show, in order. Defaults to system / light / dark
    ///     — pass explicit `label`s to localise them.
    public init(
        selection: Binding<WKAppearance>,
        options: [(value: WKAppearance, label: String)] = [
            (.system, "System"), (.light, "Light"), (.dark, "Dark"),
        ]
    ) {
        self._selection = selection
        self.options = options
    }

    public var body: some View {
        HStack(spacing: WKSpace.sm) {
            ForEach(options, id: \.value) { option in
                card(for: option.value, label: option.label)
            }
        }
    }

    private func card(for value: WKAppearance, label: String) -> some View {
        let isSelected = value == selection
        return Button {
            withAnimation(reduceMotion ? nil : WKMotion.tick) { selection = value }
        } label: {
            VStack(spacing: WKSpace.sm) {
                swatch(for: value)
                    .frame(height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: WKRadius.cell, style: .continuous))
                Text(label)
                    .wkFont(.callout)
                    .foregroundStyle(isSelected ? WKColor.textPrimary : WKColor.textSecondary)
            }
            .padding(WKSpace.md)
            .frame(maxWidth: .infinity)
            .background(WKColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                    .strokeBorder(isSelected ? WKColor.accent : WKColor.border,
                                  lineWidth: isSelected ? 2 : 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : [.isButton])
    }

    /// A miniature of what the option looks like: a flat fill for light / dark,
    /// a diagonal split for system.
    @ViewBuilder
    private func swatch(for value: WKAppearance) -> some View {
        switch value {
        case .light:
            Color(rgb: 0xF7F4EF)
        case .dark:
            Color(rgb: 0x0B0C0C)
        case .system:
            LinearGradient(
                stops: [
                    .init(color: Color(rgb: 0xF7F4EF), location: 0.5),
                    .init(color: Color(rgb: 0x0B0C0C), location: 0.5),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
}

#Preview {
    struct Demo: View {
        @State var appearance: WKAppearance = .dark
        var body: some View {
            WKThemePicker(selection: $appearance)
                .padding(WKSpace.xl)
                .background(WKColor.bg)
        }
    }
    return Demo()
}
