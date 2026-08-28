import SwiftUI

public extension View {
    /// Apply a ``WKFont`` style: font, tracking, line spacing, tabular figures,
    /// uppercasing and the Dynamic Type cap the design specifies for that style.
    ///
    /// This does not set a color — the text uses the inherited `foregroundStyle`
    /// (usually `WKColor.textPrimary`). Override with `.foregroundStyle(...)`.
    func wkFont(_ style: WKFont) -> some View {
        modifier(WKFontModifier(spec: style.spec))
    }
}

struct WKFontModifier: ViewModifier {
    let spec: WKFont.Spec

    func body(content: Content) -> some View {
        content
            .font(spec.font)
            .tracking(spec.tracking)
            .lineSpacing(spec.lineSpacing)
            .textCase(spec.uppercase ? .uppercase : nil)
            .modifier(TabularDigits(enabled: spec.tabular))
            .modifier(DynamicTypeCap(max: spec.dynamicTypeCap))
    }
}

private struct TabularDigits: ViewModifier {
    let enabled: Bool
    func body(content: Content) -> some View {
        if enabled { content.monospacedDigit() } else { content }
    }
}

private struct DynamicTypeCap: ViewModifier {
    let max: DynamicTypeSize?
    func body(content: Content) -> some View {
        if let max { content.dynamicTypeSize(...max) } else { content }
    }
}
