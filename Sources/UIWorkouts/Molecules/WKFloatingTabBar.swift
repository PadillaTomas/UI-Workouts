import SwiftUI

/// Layer 2 — a floating pill tab bar with an optional trailing circular action
/// (handoff spec §4). Fills ``WKColor/surfaceRaised``, sits ``WKSpace/lg`` from
/// the safe area. The reference's "Today / Vitals / My Health + `＋`".
public struct WKFloatingTabBar<T: Hashable>: View {
    @Binding private var selection: T
    private let items: [(value: T, systemImage: String, label: String)]
    private let trailingSystemImage: String?
    private let onTrailing: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        selection: Binding<T>,
        items: [(value: T, systemImage: String, label: String)],
        trailingSystemImage: String? = nil,
        onTrailing: (() -> Void)? = nil
    ) {
        self._selection = selection
        self.items = items
        self.trailingSystemImage = trailingSystemImage
        self.onTrailing = onTrailing
    }

    public var body: some View {
        HStack(spacing: WKSpace.sm) {
            HStack(spacing: WKSpace.xs) {
                ForEach(items, id: \.value) { item in
                    let isSelected = item.value == selection
                    Button {
                        withAnimation(reduceMotion ? nil : WKMotion.tick) {
                            selection = item.value
                        }
                    } label: {
                        HStack(spacing: WKSpace.xs) {
                            Image(systemName: item.systemImage)
                                .font(.system(size: 16, weight: .medium))
                            if isSelected {
                                Text(item.label).wkFont(.caption)
                            }
                        }
                        .foregroundStyle(isSelected ? WKColor.bg : WKColor.textSecondary)
                        .padding(.horizontal, isSelected ? WKSpace.md : WKSpace.sm)
                        .frame(minWidth: WKSize.minTarget, minHeight: WKSize.minTarget)
                        .background {
                            if isSelected {
                                Capsule(style: .continuous).fill(WKColor.textPrimary)
                            }
                        }
                        .contentShape(Capsule(style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.label)
                    .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : [.isButton])
                }
            }
            .padding(WKSpace.xs)
            .background(WKColor.surfaceRaised, in: Capsule(style: .continuous))
            .shadow(color: .black.opacity(0.24), radius: 18, y: 6)

            if let trailingSystemImage, let onTrailing {
                Button(action: onTrailing) {
                    Image(systemName: trailingSystemImage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(WKColor.bg)
                        .frame(width: WKSize.timerControl, height: WKSize.timerControl)
                        .background(Circle().fill(WKColor.textPrimary))
                        .shadow(color: .black.opacity(0.24), radius: 18, y: 6)
                }
                .buttonStyle(WKPressStyle())
                .accessibilityLabel("Add")
            }
        }
        .padding(WKSpace.lg)
    }
}

#Preview {
    struct Demo: View {
        @State var tab = "today"
        var body: some View {
            ZStack(alignment: .bottom) {
                WKColor.bg.ignoresSafeArea()
                WKFloatingTabBar(selection: $tab, items: [
                    (value: "today", systemImage: "sun.max", label: "Today"),
                    (value: "plan", systemImage: "calendar", label: "Plan"),
                    (value: "you", systemImage: "person", label: "You")
                ], trailingSystemImage: "plus", onTrailing: {})
            }
        }
    }
    return Demo()
}
