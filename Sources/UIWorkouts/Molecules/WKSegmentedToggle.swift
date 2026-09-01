import SwiftUI

/// Layer 2 — a 2–3 option mutually-exclusive toggle (handoff spec §4). Selected
/// segment = ``WKColor/textPrimary`` fill + ``WKColor/bg`` label, on a
/// ``WKColor/surfaceSunken`` pill track — the reference's "Sleep debt / Total
/// sleep" control.
public struct WKSegmentedToggle<T: Hashable>: View {
    @Binding private var selection: T
    private let options: [(value: T, label: String)]

    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(selection: Binding<T>, options: [(value: T, label: String)]) {
        self._selection = selection
        self.options = options
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.value) { option in
                let isSelected = option.value == selection
                Button {
                    withAnimation(reduceMotion ? nil : WKMotion.tick) {
                        selection = option.value
                    }
                } label: {
                    Text(option.label)
                        .wkFont(.callout)
                        .foregroundStyle(isSelected ? WKColor.bg : WKColor.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: WKSize.minTarget)
                        .background {
                            if isSelected {
                                Capsule(style: .continuous)
                                    .fill(WKColor.textPrimary)
                                    .matchedGeometryEffect(id: "thumb", in: namespace)
                            }
                        }
                        .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(option.label)
                .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : [.isButton])
            }
        }
        .padding(WKSpace.xs)
        .background(WKColor.surfaceSunken, in: Capsule(style: .continuous))
    }
}

#Preview {
    struct Demo: View {
        @State var mode = "debt"
        var body: some View {
            WKSegmentedToggle(selection: $mode, options: [
                (value: "debt", label: "Sleep debt"),
                (value: "total", label: "Total sleep")
            ])
            .padding(WKSpace.xl)
            .background(WKColor.bg)
        }
    }
    return Demo()
}
