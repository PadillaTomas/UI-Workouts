import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Color {
    /// Build an opaque color from a `0xRRGGBB` integer.
    init(rgb hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }

    /// A color that resolves to `light` or `dark` from the trait environment, so
    /// call sites never branch on `colorScheme`. Mirrors the design doc's
    /// `Color(light:dark:)` intent.
    init(light: UInt32, dark: UInt32) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(rgb: dark)
                : UIColor(rgb: light)
        })
        #else
        self.init(rgb: light)
        #endif
    }
}

#if canImport(UIKit)
extension UIColor {
    convenience init(rgb hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
#endif
