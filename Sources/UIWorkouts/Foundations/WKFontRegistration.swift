import CoreText
import Foundation

/// Registers the bundled DM Sans / DM Mono faces with Core Text the first time a
/// `WKFont` resolves — so a consuming app needs no `UIAppFonts` entry and no
/// launch call. Idempotent: the `static let` runs its closure exactly once.
enum WKFontRegistration {
    static let run: Void = {
        let files = ["DMSans", "DMMono-Light", "DMMono-Regular", "DMMono-Medium",
                     "InstrumentSerif-Regular", "InstrumentSerif-Italic"]
        for name in files {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf",
                                              subdirectory: "Fonts")
                ?? Bundle.module.url(forResource: name, withExtension: "ttf")
            else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()
}
