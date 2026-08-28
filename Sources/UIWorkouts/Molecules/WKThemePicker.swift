import SwiftUI

/// Layer 2 — the appearance picker: three swatch cards for light / dark / system.
public struct WKThemePicker: View {
    @Binding private var selection: WKThemeMode

    public init(selection: Binding<WKThemeMode>) {
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: WKSpace.md) {
            ForEach(WKThemeMode.allCases) { mode in
                Button {
                    selection = mode
                } label: {
                    VStack(spacing: WKSpace.sm) {
                        swatch(for: mode)
                            .frame(height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: WKRadius.cell,
                                                        style: .continuous))
                        Text(mode.label)
                            .wkFont(.callout)
                            .foregroundStyle(WKColor.textSecondary)
                    }
                    .padding(WKSpace.md)
                    .frame(maxWidth: .infinity)
                    .background(WKColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                            .strokeBorder(selection == mode ? WKColor.accent : WKColor.border,
                                          lineWidth: selection == mode ? 1.5 : 1)
                    )
                }
                .buttonStyle(WKPressStyle())
                .accessibilityLabel(mode.label)
                .accessibilityAddTraits(selection == mode ? [.isSelected] : [])
            }
        }
    }

    @ViewBuilder private func swatch(for mode: WKThemeMode) -> some View {
        switch mode {
        case .light:
            Color(rgb: 0xFAF8F5)
        case .dark:
            Color(rgb: 0x171614)
        case .system:
            LinearGradient(
                colors: [Color(rgb: 0xFAF8F5), Color(rgb: 0x171614)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
}

#Preview {
    WKThemePicker(selection: .constant(.system))
        .padding(WKSpace.lg)
        .background(WKColor.bg)
}
