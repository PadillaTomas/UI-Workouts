import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Color {
    /// Build an opaque color from a `0xRRGGBB` integer.
    ///
    /// The system has a **single appearance** ("Ambient Dark") — there is no
    /// light/dark split, so every token is one fixed value and call sites never
    /// branch on `colorScheme`.
    init(rgb hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
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
